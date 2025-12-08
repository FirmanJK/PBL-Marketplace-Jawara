import 'package:flutter/material.dart';

/// Responsive Grid View untuk menggantikan tabel
/// Otomatis adjust jumlah kolom berdasarkan lebar layar
class ResponsiveGridView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final double minItemWidth;
  final double childAspectRatio;
  final double crossAxisSpacing;
  final double mainAxisSpacing;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final bool isLoading;

  const ResponsiveGridView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.minItemWidth = 300,
    this.childAspectRatio = 1.0,
    this.crossAxisSpacing = 12,
    this.mainAxisSpacing = 12,
    this.padding = const EdgeInsets.all(16),
    this.physics,
    this.shrinkWrap = false,
    this.emptyWidget,
    this.loadingWidget,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return emptyWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada data',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate number of columns based on screen width
        final crossAxisCount = (constraints.maxWidth / minItemWidth).floor();
        final actualCrossAxisCount = crossAxisCount < 1 ? 1 : crossAxisCount;

        return GridView.builder(
          padding: padding,
          physics: physics,
          shrinkWrap: shrinkWrap,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: actualCrossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: crossAxisSpacing,
            mainAxisSpacing: mainAxisSpacing,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemBuilder(context, items[index], index);
          },
        );
      },
    );
  }
}

/// Card template untuk grid item
class GridItemCard extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final List<Widget>? details;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final Color? statusColor;
  final String? statusLabel;

  const GridItemCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.details,
    this.actions,
    this.onTap,
    this.statusColor,
    this.statusLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with leading and status
              Row(
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (statusLabel != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (statusColor ?? Colors.grey).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        statusLabel!,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: statusColor ?? Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),

              // Details
              if (details != null && details!.isNotEmpty) ...[
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 8),
                ...details!,
              ],

              // Actions
              if (actions != null && actions!.isNotEmpty) ...[
                const Spacer(),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Detail row untuk grid item card
class DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? iconColor;

  const DetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor ?? Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// List View alternative untuk data yang lebih cocok dalam format list
class ResponsiveListView<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final EdgeInsets padding;
  final ScrollPhysics? physics;
  final bool shrinkWrap;
  final Widget? emptyWidget;
  final Widget? loadingWidget;
  final bool isLoading;
  final Widget? separator;

  const ResponsiveListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(16),
    this.physics,
    this.shrinkWrap = false,
    this.emptyWidget,
    this.loadingWidget,
    this.isLoading = false,
    this.separator,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ??
          const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return emptyWidget ??
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inbox_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Tidak ada data',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          );
    }

    return ListView.separated(
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: items.length,
      separatorBuilder: (context, index) =>
          separator ?? const SizedBox(height: 12),
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );
  }
}
