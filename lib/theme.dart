import 'package:crypto_info/core/colors.dart'; // Імпортуємо кольори, визначені в CustomColors
import 'package:flutter/material.dart'; // Імпортуємо матеріальні віджети Flutter

// Оголошення стандартної теми для додатку
ThemeData defaultTheme = ThemeData(
  // Фон для скелетного екрана (основний фон)
  scaffoldBackgroundColor: CustomColors.backgroundColor,

  // Налаштування для AppBar
  appBarTheme: AppBarTheme(
    backgroundColor: CustomColors.primaryColor, // Колір фону AppBar
    iconTheme:
        IconThemeData(color: CustomColors.white), // Колір іконок в AppBar
    titleTextStyle: TextStyle(
      color: CustomColors.white, // Колір тексту в заголовку
      fontSize: 22, // Розмір шрифта
      fontWeight: FontWeight.bold, // Жирний шрифт
    ),
  ),

  // Налаштування тексту на різних екранах
  textTheme: TextTheme(
    bodyLarge: TextStyle(
      color: CustomColors.black, // Колір тексту в основному тілі
      fontSize: 16, // Розмір шрифта
      fontWeight: FontWeight.w400, // Нормальна вага шрифта
    ),
    bodyMedium: TextStyle(
      color: CustomColors.grey, // Колір для середнього тексту
      fontSize: 14, // Розмір шрифта
      fontWeight: FontWeight.w400, // Нормальна вага шрифта
    ),
    displayLarge: TextStyle(
      color: CustomColors.primaryColor, // Колір для великого тексту
      fontSize: 28, // Розмір шрифта
      fontWeight: FontWeight.bold, // Жирний шрифт
    ),
    displayMedium: TextStyle(
      color:
          CustomColors.secondaryColor, // Колір для середнього великого тексту
      fontSize: 24, // Розмір шрифта
      fontWeight: FontWeight.bold, // Жирний шрифт
    ),
  ),

  // Основний колір програми
  primaryColor: CustomColors.primaryColor,

  // Колір для підказок в текстових полях
  hintColor: CustomColors.secondaryColor,

  // Налаштування кнопок
  buttonTheme: ButtonThemeData(
    buttonColor: CustomColors.primaryColor, // Колір кнопок
    textTheme: ButtonTextTheme.primary, // Тема для тексту на кнопках
    shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16)), // Форма кнопок (округлені кути)
  ),

  // Налаштування карток (Card)
  cardTheme: CardTheme(
    color: CustomColors.white, // Колір карток
    shadowColor: Colors.black.withValues(alpha: 0.5), // Колір тіні карток
    elevation: 4, // Глибина тіні
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16), // Округлені кути карток
    ),
  ),

  // Налаштування для полів введення тексту (TextField)
  inputDecorationTheme: InputDecorationTheme(
    border: OutlineInputBorder(
      borderSide:
          BorderSide(color: CustomColors.grey), // Колір межі текстових полів
      borderRadius: BorderRadius.circular(12), // Округлені кути полів введення
    ),
    focusedBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: CustomColors.primaryColor), // Колір межі при фокусі
      borderRadius: BorderRadius.circular(12), // Округлені кути при фокусі
    ),
    hintStyle:
        TextStyle(color: CustomColors.grey), // Колір підказок в текстових полях
  ),

  // Налаштування для іконок
  iconTheme: IconThemeData(
    color: CustomColors.primaryColor, // Колір всіх іконок
  ),

  // Налаштування для панелі навігації
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: CustomColors.white, // Колір фону панелі навігації
    selectedItemColor: CustomColors.primaryColor, // Колір вибраного елемента
    unselectedItemColor: CustomColors.grey, // Колір не вибраного елемента
    showUnselectedLabels: true, // Показувати мітки для не вибраних елементів
    type: BottomNavigationBarType.fixed, // Тип панелі навігації
  ),
);
