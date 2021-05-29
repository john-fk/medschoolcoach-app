'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  "favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"main.dart.js": "3867f49ed806288395e90a1894dc10e2",
"index.html": "19d8a3c7c2e02fd0414b952fb2db4a9d",
"/": "19d8a3c7c2e02fd0414b952fb2db4a9d",
"assets/fonts/MaterialIcons-Regular.otf": "4e6447691c9509f7acdbf8a931a85ca1",
"assets/FontManifest.json": "fb5d5d5f32989d5b6f27c5766c7cedcf",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "6d342eb68f170c97609e9da345464e5e",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "e7006a0a033d834ef9414d48db3be6fc",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/assets/fonts/Rubik-Bold.ttf": "9a6fb6f5cd3aa4ab1adaaab1f693f266",
"assets/assets/fonts/Rubik-Regular.ttf": "b3d0902b533ff4c4f1698a2f96ddabab",
"assets/assets/fonts/Rubik-Medium.ttf": "c87313aa86b7caa31a9a0accaa584970",
"assets/assets/svg/touch.svg": "e382446cf70e7594d6b4c33a693f4166",
"assets/assets/svg/profile_bookmark.svg": "baddd1f2464b0423bbeae405f1bd3bfe",
"assets/assets/svg/Sociology.svg": "fd0e4f0df3d87ecd988895c0e1daaf9a",
"assets/assets/svg/person_outline.svg": "4cd74b15489a21d23310c1a3c5851575",
"assets/assets/svg/videos.svg": "59b46db34537d90ed3cdc3dade2f34e2",
"assets/assets/svg/empty_milestone.svg": "2071c51c0bbb41e50bee7c66c2e8fc2e",
"assets/assets/svg/support.svg": "4c5ed81aeec353023a5062e1cf69fc8b",
"assets/assets/svg/profile_logout.svg": "80c82c3268fa1d1abdccc04090a3a8ff",
"assets/assets/svg/pick_schedule.svg": "a08993fc99a82b427c8cc61c61c54460",
"assets/assets/svg/rotate.svg": "4fd6968d844259c34286b6cdb1d0d790",
"assets/assets/svg/previous_video.svg": "12f15b9110de3dd16e3dc7a8726d4cdc",
"assets/assets/svg/profile_test_date.svg": "9c3bdce75ec567ce30af42e463fb0e76",
"assets/assets/svg/ref_screen.svg": "e6af4c7c32105cf7da1e0e23ee2e029a",
"assets/assets/svg/close.svg": "398141e930efac6c19294b91d63250ab",
"assets/assets/svg/question_milestone.svg": "05585694fde9f9d147ef27f892c23bbb",
"assets/assets/svg/banner.svg": "7c1b1938648ff817d6b02451a42318d0",
"assets/assets/svg/tips.svg": "c8c9077db909059bda0bcdf4a15aa5aa",
"assets/assets/svg/ref_people.svg": "bd75a5b04b6bf1a7b6fd199edc1795e5",
"assets/assets/svg/Psychology.svg": "1f6b905b1c4526d602f9a67d8ff7ecd9",
"assets/assets/svg/profile_stopwatch.svg": "2ab7cc0538fac3d504eabb6ecccee204",
"assets/assets/svg/flash_card_background.svg": "209265241f13a4dd0ca8e3b517d56eb6",
"assets/assets/svg/Organic%2520Chemistry.svg": "ebe05bfd633f593433656cd190314920",
"assets/assets/svg/General%2520Chemistry.svg": "6ecb3562f2d025e3c85950f313457400",
"assets/assets/svg/flashcards.svg": "669abfcffd146fc6d1d6f5e4737efa69",
"assets/assets/svg/minimize_video.svg": "17f7891df934def6478b9e275619ce3f",
"assets/assets/svg/swipe_left.svg": "5797a3f9bfa2f8155ad197e2d3e06061",
"assets/assets/svg/rocket.svg": "9f6ad93bdbf2d4a3dd6279b0df626154",
"assets/assets/svg/questions.svg": "37350154a1b44448ae9f288eddd7045c",
"assets/assets/svg/back_arrow_dark.svg": "bfa679ef38d3df5b318bc57845f4514f",
"assets/assets/svg/Biology.svg": "09c44fd7d3699efe5c10cdd564b01dfd",
"assets/assets/svg/search_active.svg": "688adba07c94f0f541a72efe9715b7f6",
"assets/assets/svg/man_on_books.svg": "f3b891606dded11bb5923d4dd06152a4",
"assets/assets/svg/science_lady.svg": "f0ef2ceb5fe1e1d82d9e30550c2807a6",
"assets/assets/svg/play_video.svg": "c936f648df5cf68759f1ca13125eb10f",
"assets/assets/svg/search.svg": "03ffbdd78705e1978fa88ea1ebe2f569",
"assets/assets/svg/Biochemistry.svg": "b4e77cbb48e35e169dbba32f0bf35bbd",
"assets/assets/svg/play.svg": "77b7f474d600f70b62030fa3efcf8956",
"assets/assets/svg/profile_account.svg": "c37ebc6e285a78facf83dd09564b8870",
"assets/assets/svg/Physics.svg": "fd56e70c75cbf36d5d893e62c2d1d7e5",
"assets/assets/svg/star1.svg": "5749de6daa9d63217402b73ea916bb72",
"assets/assets/svg/ref_background.svg": "1a22f6df609af1c683478da59a89a69a",
"assets/assets/svg/notification.svg": "b53dffa137c036ec6b409e867ee16c0d",
"assets/assets/svg/time_icon.svg": "2ab7cc0538fac3d504eabb6ecccee204",
"assets/assets/svg/notes.svg": "e2ff4ffcbdaa8b74e403ffe36a1003e2",
"assets/assets/svg/yt.svg": "44466bcaafcad24c097cab39b73147a3",
"assets/assets/svg/question_background.svg": "3fcc9dba8c9ab1712675776beb088d11",
"assets/assets/svg/video_milestone.svg": "eea207356bd12160e9431ae2134eed8c",
"assets/assets/svg/swipe_right.svg": "4849810b70f3bf05ec9798079a66584a",
"assets/assets/svg/star.svg": "3f2cdcb8919b49873db76481b511ccd2",
"assets/assets/svg/flashcard_milestone.svg": "ea80c02df2f7f47713f4b28fcd0946c4",
"assets/assets/svg/welcome_screen_background.svg": "8fe291f906dd4ca2fc88bb67b34142df",
"assets/assets/svg/reconnect_video.svg": "57bfee5e8f4a414b0de30865b8348337",
"assets/assets/svg/pause_video.svg": "72893043ef9ced986cd98af6d9b59ad4",
"assets/assets/svg/profile_question_of_the_day.svg": "5c083d9e390eceb1c20373fc5f2cc557",
"assets/assets/svg/test_date.svg": "3238ab7e1243e96a7d45565e419e9e25",
"assets/assets/svg/next_video.svg": "d178b57b456d4234f4141d9cfd88b681",
"assets/assets/svg/login_header.svg": "a445fce7ac402b22ade436cb7612cb39",
"assets/assets/svg/alarmclock.svg": "48f3d67e08e8670ac5ecdf556febb18d",
"assets/assets/png/premium_modal_star.png": "8309cd98b352cfeeea7365b604a6b464",
"assets/assets/png/popup_tutor_1.png": "2fbb1dcd5ecc82d8b2e6cb702df22e5b",
"assets/assets/png/question_arrow_next.png": "c883ebb0c3b6e7e5004318eeac1d4789",
"assets/assets/png/negative.png": "75c2de88a395a44ea76415593e7ac532",
"assets/assets/png/slider_1.png": "b426aeffc104de8a82c12d144e9ea99b",
"assets/assets/png/learn_selected.png": "cba8bdf6a8dbeb844ad807759697e952",
"assets/assets/png/e_neutral.png": "d74f0dab3325621b1f477f0e05429a51",
"assets/assets/png/qbCorrect.png": "0f0d7438f9a7d3f9b78d137369014ba7",
"assets/assets/png/profile_selected.png": "1fd7773e28e58f6e968b619418f52d4a",
"assets/assets/png/onboarding_banner4.png": "29c04dad1014271803964b7d4c717586",
"assets/assets/png/qbIncorrect.png": "a50547c0319950df32e32cd56461617e",
"assets/assets/png/podcast_google.png": "2e78ef971bb97477bd1e7faab7b01bf7",
"assets/assets/png/qbCorrectFlip.png": "f5510175490f5b280f8924d7d06ae7fa",
"assets/assets/png/onboarding_banner1.png": "f7e98ece997a05a1a9d4d1228dd1b4c6",
"assets/assets/png/flip_tips1.png": "ce504bb5f7750dac9bd0dcd24ba7d714",
"assets/assets/png/bookmark_0.png": "eac865fcd7386df3dc2d3feed9e3bd09",
"assets/assets/png/tutoring_screen_unchecked.png": "28633ae2922f7e23ab1318c005a3d6ad",
"assets/assets/png/banner2.png": "d9f23e8df7a2ac54d0aea41c2124d629",
"assets/assets/png/banner3.png": "fa545819343a5b8a3b93c703b4804d37",
"assets/assets/png/progress_selected.png": "8272bef702eaa4553319fa18effda039",
"assets/assets/png/explanation.png": "0ab465b3b9c24ba233c0b01f0eee6893",
"assets/assets/png/qbIncorrectFlip.png": "1ce119982b2c6191ef9d4a2c45fd4d90",
"assets/assets/png/positive.png": "0131078d254e1778e0d22692c847aec8",
"assets/assets/png/podcast_apple.png": "91319232fb381c1883bc7fb546838c67",
"assets/assets/png/e_negative.png": "048d06e9c7a92937711560666f62f363",
"assets/assets/png/facebook.png": "4b3499deba3325a6d461dc9e8a8e0f76",
"assets/assets/png/neutral.png": "a7073ac17bedc8276af675e27714e26d",
"assets/assets/png/upsell_banner_graphic.png": "028841ba2b83a0fb5d7c64db1b215fd9",
"assets/assets/png/logo.png": "24e4c4f939974a293183827713effc38",
"assets/assets/png/learn_unselected.png": "be09458428794f3b0898f617c819715b",
"assets/assets/png/home_selected.png": "a8eb158f58325547fd0c9b62469bef72",
"assets/assets/png/e_positive.png": "8e018f73dda3f4fad1614ec8dc4e74ba",
"assets/assets/png/flip_tips5.png": "aa1fd7ff5575b154410295f8f3467850",
"assets/assets/png/global_doctors.png": "6834c2243c6bd9185a91397c5945cf78",
"assets/assets/png/support.png": "fe8aeba8c259f6f6e95b759013dcbf8e",
"assets/assets/png/old_user_onboarding.png": "91677c5afed20938cca3cb25bea4913d",
"assets/assets/png/schedule_picker.png": "64c682816932c3e0ef323f35d1d0cbb5",
"assets/assets/png/icon_close.png": "082b1e355dc5193e2c97aea379d6846d",
"assets/assets/png/course_completed.png": "9d3f28521e76e43813ebc3db1f43bb85",
"assets/assets/png/premium_modal.png": "66ba90a1359ceba56535ded8681801ee",
"assets/assets/png/bookmark_1.png": "837d85d9ee3e7439a72b9147be0a99b7",
"assets/assets/png/popup_tutor_2.png": "b1a7d481effe13c91588bae237128623",
"assets/assets/png/onboarding_banner3.png": "4d2f549be1aab4d89d38d0a113ca1e5b",
"assets/assets/png/empty_state.png": "6bb414622aadb1bf62412c8d0da11ffb",
"assets/assets/png/2.0x/popup_tutor_1.png": "43a0eb7e62dc55782254769aaee1640f",
"assets/assets/png/2.0x/question_arrow_next.png": "db7077b2b803f028c04fff26d4b94a90",
"assets/assets/png/2.0x/slider_1.png": "3c3a50293961fdce0a97deb46226c065",
"assets/assets/png/2.0x/learn_selected.png": "91ab53c56f23b97bfbee649b0f6220c1",
"assets/assets/png/2.0x/e_neutral.png": "33ada259c9f1e8f59e75cf11fc2b0d51",
"assets/assets/png/2.0x/qbCorrect.png": "a624bd360c400321f056e5394464e436",
"assets/assets/png/2.0x/profile_selected.png": "d86ae04baca77f4e63d7c0e8a7f94664",
"assets/assets/png/2.0x/onboarding_banner4.png": "001e0a864266d1142c21fa950a6ea54c",
"assets/assets/png/2.0x/qbIncorrect.png": "97fac0505cdee06c6dd8d458e21c2130",
"assets/assets/png/2.0x/qbCorrectFlip.png": "6e5929823a146b7f0ac166b184beb8d6",
"assets/assets/png/2.0x/onboarding_banner1.png": "937333e8db2d89ea6c363f30e8eb450b",
"assets/assets/png/2.0x/flip_tips1.png": "278e5edbc12e824aa779fb252a76cbf5",
"assets/assets/png/2.0x/bookmark_0.png": "0c1326a47155bd952b16238ef4be38b6",
"assets/assets/png/2.0x/tutoring_screen_unchecked.png": "1a7994b465ccb2c7eb279ce0f62d9b9c",
"assets/assets/png/2.0x/banner2.png": "7eb6e379fe54e56ecab924a98181cd7a",
"assets/assets/png/2.0x/banner3.png": "430cf17f606dd8c9c9fe75250e6f086c",
"assets/assets/png/2.0x/progress_selected.png": "17d05098f7f276889ac3a9d9cf6684a0",
"assets/assets/png/2.0x/explanation.png": "e8fbbff3cb1010672a09270e41c12d91",
"assets/assets/png/2.0x/qbIncorrectFlip.png": "5743e5bc14ad54eec6b7105d907312df",
"assets/assets/png/2.0x/e_negative.png": "167c65147e6b40eeb1cfa541e8e20e71",
"assets/assets/png/2.0x/upsell_banner_graphic.png": "8470d20a59cb752ba8cbf03ccdf14959",
"assets/assets/png/2.0x/learn_unselected.png": "817d64416f4e39547af624ed57af1d4b",
"assets/assets/png/2.0x/home_selected.png": "b1461e5477d0f3932491c966cb4079da",
"assets/assets/png/2.0x/e_positive.png": "9599704c380e9c30601cf0dc1043c588",
"assets/assets/png/2.0x/flip_tips5.png": "61c030166a5c35af48931fc0dd0f9434",
"assets/assets/png/2.0x/global_doctors.png": "84767fcc44013ded61c483b4e05909a6",
"assets/assets/png/2.0x/support.png": "27922dbb9b035296adc71be5fbfac964",
"assets/assets/png/2.0x/old_user_onboarding.png": "4090267a02285a7e43c52d502d0e7d8d",
"assets/assets/png/2.0x/schedule_picker.png": "cdbf293086e7012ff29a69495f1a4181",
"assets/assets/png/2.0x/icon_close.png": "a02b14fd91dd1878a70b2a9e9667cdf6",
"assets/assets/png/2.0x/course_completed.png": "a09c8dfbe34ba8d8700d264662b904bb",
"assets/assets/png/2.0x/bookmark_1.png": "d94e168ca9727bb900792cde845dbfdd",
"assets/assets/png/2.0x/popup_tutor_2.png": "e5da47c92c850c6e32822acf870023ba",
"assets/assets/png/2.0x/onboarding_banner3.png": "2d4299f1f73acba9d595a58acf6251e8",
"assets/assets/png/2.0x/empty_state.png": "e869481e6606ce6aa38980f2f4510221",
"assets/assets/png/2.0x/profile_unselected.png": "18a8beef05a66f24d1e08bbc2db47939",
"assets/assets/png/2.0x/button_explanation.png": "824effa02732b86944c39766be29772d",
"assets/assets/png/2.0x/home_unselected.png": "15e841193417e0b876bf6b8514a84abb",
"assets/assets/png/2.0x/flip_tips4.png": "f1dab04bb0c1c8f6436f069afc02ff05",
"assets/assets/png/2.0x/tutoring_slider_2.png": "eb1bee8c618827dec312ef5964f26ba3",
"assets/assets/png/2.0x/learn_schedule.png": "895ba91155a1009c24585bf7f6dacbf7",
"assets/assets/png/2.0x/onboarding_banner2.png": "71432197c7c77dba2e5e255d6896435a",
"assets/assets/png/2.0x/tutoring_screen_checked.png": "2af8137f442eca6e3eca0c92df59efc1",
"assets/assets/png/2.0x/slider_3.png": "acb1a1cb98ef5a6f4a74a5cd6eaa6f42",
"assets/assets/png/2.0x/slider_2.png": "e6eca9146c3b4c6c4dd61c452fb550ad",
"assets/assets/png/2.0x/test_date_picker.png": "f82c1ffae693ff4dd02e1e0d64f41798",
"assets/assets/png/2.0x/progress_screen_tutor.png": "601a1d3ab22a8abe377304e466d22d49",
"assets/assets/png/2.0x/practice_unselected.png": "a8b3869156aa80c076c21344fedb9950",
"assets/assets/png/2.0x/flip_tips3.png": "79e5d358ff73d382bb04ce5903a1b163",
"assets/assets/png/2.0x/banner1.png": "b1b0c84deeb0420a78cc1281772e7d60",
"assets/assets/png/2.0x/learn_tutor.png": "f87b36880f7161faaa6d287edec19646",
"assets/assets/png/2.0x/tutoring_slider_1.png": "96261f51851d48860e88f568ead36019",
"assets/assets/png/2.0x/flip_tips2.png": "9faa673cdca87b114d15bcb351d13454",
"assets/assets/png/2.0x/progress_unselected.png": "ef2fc1f0c13ed39df5c2eafe39ebc117",
"assets/assets/png/2.0x/practice_selected.png": "bb43ec6c04285b533298e6e51d15c7fd",
"assets/assets/png/2.0x/tutoring_slider_3.png": "9afc7cf65c86ff0567de30e6dbb86e09",
"assets/assets/png/profile_unselected.png": "8f6cb202c70eb7a92e9509b06733f33c",
"assets/assets/png/button_explanation.png": "651c0f139477d25e66dc35ca3d89c9e2",
"assets/assets/png/home_unselected.png": "a1b467962c944ab265dc61720a5a149f",
"assets/assets/png/flip_tips4.png": "67da08187905754c7744f674e9e405b0",
"assets/assets/png/tutoring_slider_2.png": "fc204ef06dfcfe829ccd57c8e1929417",
"assets/assets/png/podcast_sticher.png": "e5317a22e87f95e0723ebc29ff3225c0",
"assets/assets/png/learn_schedule.png": "b007ed92417498f105eaa23cc3bc89da",
"assets/assets/png/podcast_spotify.png": "aaf4bc4e473e74b5f06691e6151ef63b",
"assets/assets/png/3.0x/popup_tutor_1.png": "ff86d2a4266ec83b0df674e8421772b8",
"assets/assets/png/3.0x/question_arrow_next.png": "ef4f946b533e699da4d62fb788ddc470",
"assets/assets/png/3.0x/slider_1.png": "67d8fde779dccaafe1d70cdcf7ccf0c7",
"assets/assets/png/3.0x/learn_selected.png": "42e4a843fc38544a7746ef961bb3a9ff",
"assets/assets/png/3.0x/e_neutral.png": "69582e6470dae54928ca34235c3d9621",
"assets/assets/png/3.0x/qbCorrect.png": "d20a49cc882c41e6bda67e8ace5a009f",
"assets/assets/png/3.0x/profile_selected.png": "4ab0c6fc4370d9dac1408d7cf6579ff9",
"assets/assets/png/3.0x/onboarding_banner4.png": "9bb3316be583b2b2c0e08cc2f6805f79",
"assets/assets/png/3.0x/qbIncorrect.png": "3a5c3cbee34467b51886f72486a06471",
"assets/assets/png/3.0x/qbCorrectFlip.png": "f692c63d179e0b09b177eb4f9b947e99",
"assets/assets/png/3.0x/onboarding_banner1.png": "03d8598084bdeaae17de3320bb9bacd7",
"assets/assets/png/3.0x/flip_tips1.png": "d82766b33566cd53cd45b58842a0c7cd",
"assets/assets/png/3.0x/bookmark_0.png": "9dc4c18922b99503b74b620464bc8773",
"assets/assets/png/3.0x/tutoring_screen_unchecked.png": "193fffde09cace0797cabf98861e97bb",
"assets/assets/png/3.0x/banner2.png": "6958bb95f5468272a26acdbc2ad19cdc",
"assets/assets/png/3.0x/banner3.png": "fdcf491a0c84eb169d0d197260e0db4c",
"assets/assets/png/3.0x/progress_selected.png": "5b14aa620b9ccd9ed855b5aecf7a8d0c",
"assets/assets/png/3.0x/explanation.png": "436306981d90bfc18ad129e27ff63624",
"assets/assets/png/3.0x/qbIncorrectFlip.png": "0edb487dea3e7d05e3ae801074d3f99e",
"assets/assets/png/3.0x/e_negative.png": "22e937517fbe2daa8ee9f7765ab1629e",
"assets/assets/png/3.0x/upsell_banner_graphic.png": "8347e226b40783c8841637a74d915846",
"assets/assets/png/3.0x/learn_unselected.png": "46674c50911d826c1cf0b778ef1c7915",
"assets/assets/png/3.0x/home_selected.png": "b0f19832ff5b2968dee1b9e0eaeca74d",
"assets/assets/png/3.0x/e_positive.png": "0f021190648ec20a10b86433e02edf2f",
"assets/assets/png/3.0x/flip_tips5.png": "383f9d5cfcc23b9cf3866746b15d187b",
"assets/assets/png/3.0x/global_doctors.png": "8ce72fb9a71a68953c78a8e67d6d484f",
"assets/assets/png/3.0x/support.png": "48d13f4fdcb74d0e5bd7b3d3f1848e67",
"assets/assets/png/3.0x/old_user_onboarding.png": "b43bfa81f59ec9c4600fc0907f0e4245",
"assets/assets/png/3.0x/schedule_picker.png": "0c74174b8a592da4936fe6d8bf6c17a6",
"assets/assets/png/3.0x/icon_close.png": "a02b14fd91dd1878a70b2a9e9667cdf6",
"assets/assets/png/3.0x/course_completed.png": "0f2992172a229c0663e525281db2dd71",
"assets/assets/png/3.0x/bookmark_1.png": "bcb1d10fa3b3e49640d29e592f781e18",
"assets/assets/png/3.0x/popup_tutor_2.png": "843578e80cb889ed7aa10ee177e44a00",
"assets/assets/png/3.0x/onboarding_banner3.png": "b21e4271adf71444e4b21bbc5b4d25a4",
"assets/assets/png/3.0x/empty_state.png": "d73f8999fc40c8f1ad48bd51670d2bc1",
"assets/assets/png/3.0x/profile_unselected.png": "008d3294cacc713a3c8ff2853628a2b9",
"assets/assets/png/3.0x/button_explanation.png": "20ed3f2d4634ca3a85be5b0eb9fd2a3d",
"assets/assets/png/3.0x/home_unselected.png": "11c22bc4715cada2d3f157f3b98c2ea6",
"assets/assets/png/3.0x/flip_tips4.png": "b3e2b4dd2421ddcc14d15aca586f5966",
"assets/assets/png/3.0x/tutoring_slider_2.png": "505583d6b22f58b29bd2ad80872908e3",
"assets/assets/png/3.0x/learn_schedule.png": "c21c243c69e14c21062367d5f0fa78d2",
"assets/assets/png/3.0x/onboarding_banner2.png": "dc1803e9dc35bb689425f368a45d4715",
"assets/assets/png/3.0x/tutoring_screen_checked.png": "2b7b1da0f55cb2d5607f62ac3656821f",
"assets/assets/png/3.0x/slider_3.png": "4868ea119dbc4eb37a0cbfd0a2c83fc8",
"assets/assets/png/3.0x/slider_2.png": "0cf4a88ca1ecd4167fd47bff6eb0a354",
"assets/assets/png/3.0x/test_date_picker.png": "ee93743d794ada9133440a9533cf7472",
"assets/assets/png/3.0x/progress_screen_tutor.png": "fcc161ff24c0ffa325592cd82cb52f86",
"assets/assets/png/3.0x/practice_unselected.png": "75b783baaeae47e25d9b72b660274256",
"assets/assets/png/3.0x/flip_tips3.png": "4e2265b117e15925822a1adff6b9c9e9",
"assets/assets/png/3.0x/banner1.png": "5d52449139351a19cd51cb0a7137ea2c",
"assets/assets/png/3.0x/learn_tutor.png": "17dcf85e2cccafe0136e0f71006c0180",
"assets/assets/png/3.0x/tutoring_slider_1.png": "f15e32b4abc9209dd56e297e28dd4310",
"assets/assets/png/3.0x/flip_tips2.png": "017b6190421039d6b4a31139ea396665",
"assets/assets/png/3.0x/progress_unselected.png": "c05c50ae6f7f178e59930f27f4029613",
"assets/assets/png/3.0x/practice_selected.png": "503f8f3b96ebd17c891f43d4eb8664bb",
"assets/assets/png/3.0x/tutoring_slider_3.png": "fd1793615692cd384146ccae45707110",
"assets/assets/png/onboarding_banner2.png": "3bca63036e29a95a1ec750c556dfdf80",
"assets/assets/png/tutoring_screen_checked.png": "f53d7353e7913f4d0469f479fe545167",
"assets/assets/png/instagram.png": "9f84646bc416903d434ac0dab2bc26fa",
"assets/assets/png/slider_3.png": "832c8240635af93e27963a0adafdd2e3",
"assets/assets/png/slider_2.png": "e9f504de4f498b8aab561cb1ba7b8b16",
"assets/assets/png/test_date_picker.png": "d87a1b93d69d141b22ada7de1ea5b05e",
"assets/assets/png/progress_screen_tutor.png": "f785576bca008e48741f8daee79db806",
"assets/assets/png/practice_unselected.png": "36a4eef511e238e26d25106f00fef129",
"assets/assets/png/flip_tips3.png": "c794e8118f9f01eba8b68cbcee222e26",
"assets/assets/png/banner1.png": "84e87771d7857dda51b92cec89eb8f2b",
"assets/assets/png/learn_tutor.png": "a2a8b0597c372a06b87bee50f08c52d4",
"assets/assets/png/tutoring_slider_1.png": "1a31a8570bdb7f77d8ca42570830702b",
"assets/assets/png/flip_tips2.png": "84c4b67ddff8baa6325839dcfae4bcb5",
"assets/assets/png/progress_unselected.png": "abff2509266712521b27d16724485e2f",
"assets/assets/png/practice_selected.png": "04860d5a58d7bcc1a0994dace63f774e",
"assets/assets/png/tutoring_slider_3.png": "ca0a2b4fb2a8d50e7f6401e8922e661d",
"assets/assets/i18n/en_US.yaml": "81ea2b4b4c67ce3ebe0698c3bc4c89cd",
"assets/AssetManifest.json": "651d2783d5442b48cfa95f73fe3cec56",
"assets/NOTICES": "795dce43dab65739f2742b333e05ac1f",
"manifest.json": "89e14e88f02993806714fe22e4842af9",
"version.json": "f834ace1033c90ecb95537fbd2a89830"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
