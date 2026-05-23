/// Asset paths management class following OOP principles
/// This class centralizes all asset paths for easy maintenance and scalability
class CustomAssets {
  // Private constructor to prevent instantiation
  CustomAssets._();

  // Base paths
  static const String _imagesPath = 'assets/images';
  static const String _iconsPath = 'assets/icons';
  static const String _fontsPath = 'assets/fonts';

  // ============ IMAGES ============
  
  // Background Images
  static const String mainBackground = '$_imagesPath/main_background.png';
  static const String splashBackground = '$_imagesPath/main_background.png';
  
  // Logo Images
  static const String splashLogo = '$_imagesPath/splash_logo.png';
  static const String appIcon = '$_imagesPath/lOGOss.png';
  static const String logoSs = '$_imagesPath/lOGOss.png';

  
  // Onboarding Images
  static const String onBoardingFirst = '$_imagesPath/on_boarding_first_image.png';
  static const String onBoardingSecond = '$_imagesPath/on_boarding_second_image.png';
  static const String onBoardingThird = '$_imagesPath/on_boarding_third_image.png';
  
  // Success/Status Images
  static const String successImage = '$_imagesPath/success_image.png';
  
  // Bag Design Images
  static const String createLabelBag = '$_imagesPath/create_label_bag.png';
  static const String createYourFullGraphicsBag = '$_imagesPath/create_your_full_graphics_bag.png';

  static const String generateWithAi = '$_imagesPath/generate_with_ai.png';
  static const String uploadLogo = '$_imagesPath/upload_logo.png';

  static const String fullGraphics = '$_imagesPath/full_graphics.png';

  // Bag Product Images
  static const String gussetBagFull = '$_imagesPath/Gusset Bag_full_bag.png';
  static const String gussetBag = '$_imagesPath/Gusset_Bag.png';
  static const String quadSealBag = '$_imagesPath/quad_seal_bag.png';
  static const String standUpPouch = '$_imagesPath/Stand_Up_Pouch.png';
  static const String standUpPouchFull = '$_imagesPath/Stand_Up_Pouch_full_bag.png';
  
  // Full Graphic Bag Variations

  // Label Bag Variations


  static const String personimage = '$_imagesPath/person_image.png';

  static const String texttodesignimage ='$_imagesPath/text_to_design_second_page.png';
  static const String imageLoggss= '$_imagesPath/lOGOsss.png';

  // ============ ICONS ============
  
  // Social Media Icons
  static const String apple = '$_iconsPath/apple.svg';
  static const String google = '$_iconsPath/google.svg';
  
  // Navigation Icons - Collections
  static const String collectionsWithoutHover = '$_iconsPath/collections_without_hovar.svg';
  static const String collectionsWithHover = '$_iconsPath/collections_with_hovar.svg';
  
  // Navigation Icons - Create
  static const String createWithoutHover = '$_iconsPath/create_without_hovar.svg';
  static const String createWithHover = '$_iconsPath/create_with_hovar.svg';
  
  // Navigation Icons - Profile
  static const String profileWithoutHover = '$_iconsPath/profile_without_hovar.svg';
  static const String profileWithHover = '$_iconsPath/profile_with_hovar.svg';
  
  // Navigation Icons - Your Design
  static const String yourDesignWithoutHover = '$_iconsPath/your_design_without_hovar.svg';
  static const String yourDesignWithHover = '$_iconsPath/your_design_with_hovar.svg';
  
  // Other Icons
  static const String logouticon = '$_iconsPath/logout_icon.svg';

  static const String saveicon = '$_iconsPath/save_icon.svg';
  static const String showbagdesign = '$_iconsPath/show_bag_design.svg';
  static const String logoSmall = '$_iconsPath/LogoSmall.svg';


  // ============ FONTS ============
  static const String poppinsFontFamily = 'Poppins';

  /// Validates if an asset path exists in the defined constants
  /// This can be extended for runtime asset validation
  static bool isValidAsset(String path) {
    return path.startsWith(_imagesPath) ||
        path.startsWith(_iconsPath) ||
        path.startsWith(_fontsPath);
  }
  
  /// Returns all image paths
  static List<String> get allImages => [
        // Background & Logo
        mainBackground,
        splashBackground,
        splashLogo,
        appIcon,
        logoSs,
        
        // Onboarding
        onBoardingFirst,
        onBoardingSecond,
        onBoardingThird,
        
        // Success/Status
        successImage,
        
        // Design Tools
        uploadLogo,
        generateWithAi,
        fullGraphics,
        
        // Bag Creation
        createLabelBag,
        createYourFullGraphicsBag,
        
        // Bag Products
        gussetBagFull,
        gussetBag,
        quadSealBag,
        standUpPouch,
        standUpPouchFull,

        // Profile
        personimage,

        texttodesignimage,
    imageLoggss,
      ];
  
  /// Returns all icon paths
  static List<String> get allIcons => [
        apple,
        google,
        collectionsWithoutHover,
        collectionsWithHover,
        createWithoutHover,
        createWithHover,
        profileWithoutHover,
        profileWithHover,
        yourDesignWithoutHover,
        yourDesignWithHover,
        logouticon,
    saveicon,
    showbagdesign
      ];
}