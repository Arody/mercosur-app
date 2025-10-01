import 'package:flutter/material.dart';

class MetricCard extends StatelessWidget {
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    this.subtitle,
    this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Adaptar el contenido según el espacio disponible
            final isVerySmall = constraints.maxWidth < 100 || constraints.maxHeight < 80;
            final isSmall = constraints.maxWidth < 150 || constraints.maxHeight < 100;
            
            return Padding(
              padding: EdgeInsets.all(isVerySmall ? 6.0 : (isSmall ? 8.0 : 10.0)),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: constraints.maxWidth - (isVerySmall ? 12 : (isSmall ? 16 : 20)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Solo mostrar icono si hay espacio suficiente
                      if (!isVerySmall) ...[
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(isSmall ? 3 : 4),
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Icon(
                                icon,
                                color: color,
                                size: isSmall ? 12 : 14,
                              ),
                            ),
                            const Spacer(),
                            if (onTap != null)
                              Icon(
                                Icons.arrow_forward_ios,
                                size: isSmall ? 8 : 10,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                          ],
                        ),
                        SizedBox(height: isSmall ? 4 : 6),
                      ],
                      // Valor
                      Text(
                        value,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: color,
                          fontSize: isVerySmall ? 16 : (isSmall ? 20 : 24),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                      SizedBox(height: isVerySmall ? 1 : 2),
                      // Título
                      Text(
                        title,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontWeight: FontWeight.w500,
                          fontSize: isVerySmall ? 8 : (isSmall ? 9 : 11),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.visible,
                      ),
                      // Subtítulo solo si hay espacio
                      if (subtitle != null && !isVerySmall && !isSmall) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                            fontSize: 9,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
