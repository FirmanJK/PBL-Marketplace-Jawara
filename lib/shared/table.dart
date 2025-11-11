import 'package:flutter/material.dart';

class CustomDataTable extends StatefulWidget {
  final List<String> headers;
  final List<List<Widget>> rows;
  final List<String> sortable;

  const CustomDataTable({
    super.key,
    required this.headers,
    required this.rows,
    this.sortable = const [],
  });

  @override
  State<CustomDataTable> createState() => _CustomDataTableState();
}

class _CustomDataTableState extends State<CustomDataTable> {
  late List<List<Widget>> _sortedRows;
  int _sortColumnIndex = -1;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _sortedRows = List.from(widget.rows);
  }

  void _onSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _isAscending = ascending;

      _sortedRows.sort((a, b) {
        final cellA = a[columnIndex];
        final cellB = b[columnIndex];
        final valA = (cellA is Text) ? cellA.data ?? '' : cellA.toString();
        final valB = (cellB is Text) ? cellB.data ?? '' : cellB.toString();
        final comparison = valA.toLowerCase().compareTo(valB.toLowerCase());
        return ascending ? comparison : -comparison;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_sortedRows.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.inbox_rounded,
                color: Color(0xFFF59E0B),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Tidak ada data tersedia',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Data akan muncul di sini saat tersedia',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Theme(
            data: Theme.of(context).copyWith(
              dividerColor: Colors.grey[100],
              dataTableTheme: DataTableThemeData(
                headingRowColor: WidgetStateProperty.all(
                  const Color(0xFF0891B2).withValues(alpha: 0.06),
                ),
                dataRowColor: WidgetStateProperty.resolveWith<Color>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.hovered)) {
                    return const Color(0xFF0891B2).withValues(alpha: 0.04);
                  }
                  return Colors.white;
                }),
                headingTextStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: Color(0xFF0891B2),
                  letterSpacing: 0.5,
                ),
                dataTextStyle: const TextStyle(
                  fontSize: 13.5,
                  color: Color(0xFF1F2937),
                ),
              ),
            ),
            child: DataTable(
              sortColumnIndex: _sortColumnIndex == -1 ? null : _sortColumnIndex,
              sortAscending: _isAscending,
              columnSpacing: 20,
              horizontalMargin: 20,
              headingRowHeight: 52,
              dataRowHeight: 60,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              columns: List.generate(widget.headers.length, (index) {
                final header = widget.headers[index];
                final isSortable = widget.sortable
                    .map((s) => s.toLowerCase())
                    .contains(header.toLowerCase());
                return DataColumn(
                  label: Row(
                    children: [
                      Text(
                        header,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF06B6D4),
                        ),
                      ),
                      if (isSortable) ...[
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.unfold_more,
                          size: 16,
                          color: Color(0xFF06B6D4),
                        ),
                      ],
                    ],
                  ),
                  onSort: isSortable
                      ? (columnIndex, ascending) =>
                            _onSort(columnIndex, ascending)
                      : null,
                );
              }),
              rows: _sortedRows.asMap().entries.map((entry) {
                final index = entry.key;
                final row = entry.value;
                return DataRow(
                  color: WidgetStateProperty.resolveWith<Color>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.hovered)) {
                      return const Color(0xFF8B5CF6).withValues(alpha: 0.05);
                    }
                    if (index.isEven) {
                      return Colors.grey[50]!;
                    }
                    return Colors.white;
                  }),
                  cells: row.map((cell) => DataCell(cell)).toList(),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
