import 'package:flutter/material.dart';
import 'package:manga_scraper/blocs/search_bloc.dart';
import 'package:manga_scraper/theme/app_colors.dart';
import 'package:manga_scraper/theme/app_fonts.dart';
import 'package:manga_scraper/translation/language.dart';
import 'package:manga_scraper/utils/enums.dart';

class AdvancedFilterDialog extends StatefulWidget {
  final SearchBloc bloc;

  const AdvancedFilterDialog({Key key, this.bloc}) : super(key: key);

  @override
  _AdvancedFilterDialogState createState() => _AdvancedFilterDialogState();
}

class _AdvancedFilterDialogState extends State<AdvancedFilterDialog> {
  List<bool> categories;
  int selectedType;
  int selectedStatus;

  @override
  void initState() {
    categories = List.generate(MangaCategories.values.length, (index) => false);
    selectedType = 0;
    selectedStatus = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Builder(builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 10,
          backgroundColor: Colors.transparent,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width * 0.95,
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    Language.of(context).filterByGenres + ' :',
                    style: TextStyle(
                      color: AppColors.getPrimaryColor(),
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                ),
                SizedBox(height: 5),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: List.generate(
                    MangaCategories.values.length,
                    (index) => _FilterItem(
                      name: mangaCategoryToString(index, context),
                      isSelected: categories[index],
                      onClick: () {
                        setState(() {
                          categories[index] = !categories[index];
                        });
                      },
                    ),
                  ),
                ),
                // TODO: search by status
                /*Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    Language.of(context).filterByStatus + ' :',
                    style: TextStyle(
                      color: AppColors.getPrimaryColor(),
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                ),
                SizedBox(height: 5),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: List.generate(
                    MangaStatus.values.length,
                    (index) => _FilterItem(
                      name: mangaStatusToString(index + 1, context),
                      isSelected: selectedStatus == index + 1,
                      onClick: () {
                        setState(() {
                          if (selectedStatus == index + 1)
                            selectedStatus = 0;
                          else
                            selectedStatus = index + 1;
                        });
                      },
                    ),
                  ),
                ),*/
                Divider(
                  thickness: 1,
                ),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    Language.of(context).filterByType + ' :',
                    style: TextStyle(
                      color: AppColors.getPrimaryColor(),
                    ),
                    strutStyle: AppFonts.getStyle(),
                  ),
                ),
                SizedBox(height: 5),
                Wrap(
                  spacing: 10,
                  runSpacing: 5,
                  children: List.generate(
                    MangaType.values.length,
                    (index) => _FilterItem(
                      name: mangaTypeToString(index + 1, context),
                      isSelected: selectedType == index + 1,
                      onClick: () {
                        setState(() {
                          if (selectedType == index + 1)
                            selectedType = 0;
                          else
                            selectedType = index + 1;
                        });
                      },
                    ),
                  ),
                ),
                Divider(
                  thickness: 1,
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            AppColors.getPrimaryColor()),
                      ),
                      onPressed: () {
                        widget.bloc.add(StartSearch(
                          category: categoriesToString(categories, context),
                          type: selectedType,
                          status: selectedStatus,
                        ));
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          Language.of(context).search,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                          strutStyle: AppFonts.getStyle(),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            side: BorderSide(
                                color: AppColors.getPrimaryColor(), width: 1),
                          ),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Text(
                          Language.of(context).cancel,
                          style: TextStyle(
                            color: AppColors.getPrimaryColor(),
                            fontSize: 12,
                          ),
                          strutStyle: AppFonts.getStyle(),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _FilterItem extends StatelessWidget {
  final String name;
  final bool isSelected;
  final Function onClick;

  const _FilterItem({Key key, this.name, this.isSelected, this.onClick})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.getPrimaryColor() : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.getPrimaryColor(),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(
            color: isSelected ? Colors.white : AppColors.getPrimaryColor(),
            fontSize: 12,
          ),
          strutStyle: AppFonts.getStyle(),
        ),
      ),
    );
  }
}
