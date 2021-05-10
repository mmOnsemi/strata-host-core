#pragma once

#include <QByteArray>
#include <FlasherConstants.h>

// data for fake firmware/bootloader
namespace strata::FlasherTestConstants {

// default timeout for QTRY_COMPARE_WITH_TIMEOUT
constexpr int TEST_TIMEOUT = 1000;

// default timeout for QTRY_COMPARE_WITH_TIMEOUT for flash_bootloader
constexpr int TEST_TIMEOUT_BOOTLOADER = 1250;

const QByteArray fakeFirmwareData = R"(Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ac lobortis tellus. Sed mattis ultricies porta. Aliquam fringilla hendrerit felis, in ultricies odio. Quisque sit amet ex lacinia, dignissim ex et, mollis est. Pellentesque imperdiet nulla vitae velit lacinia fringilla. Integer molestie commodo felis, non condimentum ipsum aliquam ut. Sed vel orci dui.

Pellentesque massa risus, vulputate nec accumsan sed, cursus sit amet metus. Maecenas sed lobortis elit. Donec quis lectus finibus, condimentum turpis at, blandit tortor. Praesent molestie tortor eu diam blandit, et varius nunc rutrum. Vestibulum non placerat massa. Aenean vulputate nibh id pulvinar luctus. Pellentesque facilisis eros magna, et dapibus nulla vestibulum sit amet. Etiam sit amet mattis erat. In eu nulla sollicitudin, dictum dolor viverra, aliquam lectus. In nec odio a tortor tincidunt finibus. Proin efficitur, tortor eget rhoncus scelerisque, dolor dolor viverra sem, vitae maximus ante dui non nulla. Nullam fringilla eros id velit egestas, ut rutrum orci pretium. Sed volutpat quis libero quis lacinia.

Ut non dapibus turpis. Vivamus at mauris ac ligula pretium iaculis ut sed nibh. Etiam bibendum scelerisque facilisis. Mauris sit amet vulputate turpis. Aliquam lobortis quam sit amet urna volutpat suscipit eget vel nisi. Donec pharetra a purus eu imperdiet. Aenean vel sem et dolor sollicitudin tempus et vel erat. Fusce dictum leo eu tellus facilisis, mollis cursus sem lobortis. Donec tempor, urna a congue interdum, elit risus malesuada est, et auctor nulla felis ut tortor. Suspendisse congue laoreet elit in mollis.

Integer tempor purus mauris, sed elementum neque venenatis et. Fusce sed libero diam. Sed lacinia gravida augue id molestie. Cras at dapibus urna, quis ornare leo. Vivamus viverra consectetur dictum. Praesent sit amet metus tristique nisi tempor pretium. Pellentesque scelerisque augue a ultrices mattis. In hac habitasse platea dictumst. Phasellus sit amet velit odio. Pellentesque vitae ante nec felis commodo condimentum ac et est. Aliquam sollicitudin tempor tellus et varius.

Pellentesque ut venenatis magna. Sed feugiat neque eget ipsum egestas, vel hendrerit lectus cursus. Nulla vitae lacus sodales dui mollis vehicula ut a massa. Sed ultrices erat non volutpat ultrices. Nullam lobortis ultrices lorem, et laoreet ligula vulputate vel. Nulla pharetra quam eget justo egestas dapibus. Nam at fringilla mi, vel hendrerit dolor. Nam nisi dolor, dictum eu malesuada ut, mollis ut metus. Duis porttitor sollicitudin scelerisque. Nulla finibus augue ac sem euismod, nec condimentum dui pulvinar. Cras ullamcorper purus sed augue feugiat rutrum. Morbi consectetur non dui ac viverra. Pellentesque id elementum tellus. Quisque at nulla eget purus porttitor vehicula eu at nulla. Donec pulvinar urna ac tellus malesuada, sit amet dignissim mi vulputate.

Curabitur ultrices quam a sem maximus imperdiet. Cras non est urna. Nam facilisis libero ac nibh tincidunt, venenatis aliquam augue tempus. Pellentesque ultricies arcu in magna ornare tincidunt. Nunc non commodo velit. Nulla venenatis lacus eget fermentum hendrerit. Phasellus malesuada sit amet metus id sodales. Suspendisse non tincidunt quam.

Nulla ac velit ac augue hendrerit venenatis. Etiam odio mi, pharetra et augue quis, malesuada laoreet ligula. Curabitur ligula purus, fermentum eu urna vel, ultrices lacinia neque. Nunc fermentum, nunc eu porttitor ornare, purus risus mollis erat, vel dictum arcu nibh nec enim. Quisque sapien nunc, laoreet eu semper sit amet, feugiat sed lectus. Nullam eleifend fringilla aliquam. Cras accumsan egestas rutrum. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Proin a lorem vel odio mattis porttitor. Fusce dapibus rutrum est sed vulputate. Aliquam consectetur pulvinar elit eu eleifend. Nullam eleifend odio ante, a imperdiet ex ornare quis. Duis dolor nisi, consequat at egestas ut, bibendum id purus. Fusce semper cursus sapien, semper luctus nisl gravida nec.

Donec ultricies tortor odio, a tristique massa malesuada eget. Aliquam in ipsum placerat, fermentum nisl eget, posuere nulla. Cras sagittis suscipit augue nec dictum. Quisque in ligula et lorem dapibus accumsan nec sed purus. Pellentesque libero purus, auctor quis pretium eget, maximus id libero. Nulla sit amet vehicula enim, eu maximus erat. Donec felis sapien, fermentum non tortor at, fringilla dapibus quam. Morbi et placerat felis. Proin fermentum nulla nec libero commodo, vitae fermentum dolor euismod. Pellentesque ut libero eu est scelerisque egestas. Nunc quam elit, lobortis sit amet facilisis eget, ullamcorper eu nibh. Proin tempus lorem vel velit hendrerit, vitae consectetur quam porttitor. Morbi venenatis enim at scelerisque cursus. Maecenas dictum, tortor sit amet tempor varius, tortor lorem sodales ipsum, non aliquet lacus orci porta neque.

Curabitur tempus finibus leo, sed hendrerit elit mattis et. Etiam in semper risus. Duis dui lacus, porttitor id tincidunt nec, ullamcorper rhoncus nulla.)";

const QByteArray fakeBootloaderData = R"(Maecenas velit turpis, cursus id turpis quis, tincidunt elementum tortor. Nullam ultrices in est non aliquet. Pellentesque sodales luctus semper. Mauris in nulla condimentum, rutrum nibh vitae, pulvinar lorem. Nulla id sapien iaculis, finibus lectus in, vestibulum lectus. Nunc a sapien sed tortor hendrerit sodales. Etiam enim velit, egestas ut nibh nec, imperdiet egestas elit. Fusce eget sem cursus enim consectetur fringilla. Nulla venenatis tempor nisi eu imperdiet. Sed at urna felis. Phasellus id leo velit. Nam in ornare nisl, a consectetur eros. Proin ac ante ut orci auctor blandit. Nunc luctus odio non maximus pulvinar.

Donec congue elit purus, eget porta neque bibendum in. Vivamus congue lorem a mattis scelerisque. Vestibulum commodo scelerisque faucibus. Nunc egestas leo at iaculis sagittis. Aliquam nisl ligula, egestas in purus feugiat, efficitur tincidunt tortor. Morbi eleifend felis velit. Sed ante leo, tincidunt vel erat id, iaculis fringilla eros. Vivamus a tortor vel arcu lobortis vestibulum. Nunc viverra, eros sit amet posuere posuere, odio mi congue orci, a sagittis ligula magna sed sapien. Maecenas ac urna et neque auctor tempor in vitae elit. Praesent vulputate urna augue, non consequat nunc finibus eu. Vestibulum non tortor faucibus, congue nisl id, ultrices ante. Nullam bibendum feugiat venenatis. Aenean eget urna condimentum, dapibus orci sed, sagittis massa. Integer nec pulvinar ipsum, ac consequat lectus.

Sed at lacinia ligula. Vestibulum at risus vitae velit lobortis dictum in ac est. Proin tincidunt id massa sed ullamcorper. Phasellus lacus ipsum, interdum ut congue a, posuere et turpis. Quisque placerat, est vel pretium interdum, libero nibh lacinia augue, ut volutpat lectus augue non lorem.

Ut id sapien nec neque gravida feugiat a nec arcu. Integer id est sit amet tellus ultricies feugiat. Nunc eget lectus quis velit venenatis iaculis. Nunc nec malesuada nunc. Integer ut libero sagittis, gravida nisi eget, aliquam risus.

Nunc malesuada, ipsum eu dapibus euismod, tortor nibh bibendum ex, a feugiat turpis elit id libero. Fusce laoreet, eros sagittis vestibulum dapibus, purus orci pulvinar nisi, dignissim egestas quam sapien vel enim. Cras consequat, purus vitae iaculis mattis, nisl tortor lobortis nibh, pulvinar consequat purus justo nec lacus. Nunc rhoncus aliquet accumsan. Aliquam vitae diam tristique, finibus lectus a, pulvinar diam. Maecenas iaculis ex vitae quam placerat, vitae maximus neque vehicula. Nunc vel rhoncus justo, imperdiet mattis diam. Etiam rhoncus consectetur volutpat.)";

const QByteArray fakeFirmwareBackupData = "";

} // namespace strata::FlasherTestConstants
