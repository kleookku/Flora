//
//  Elog.h
//  Flora
//
//  Created by Kleo Ku on 8/10/22.
//

#ifndef Elog_h
#define Elog_h

#ifdef DEBUG
#    define Elog(...) NSLog(__VA_ARGS__)
#else
#    define Elog(...) /* */
#endif


#endif /* Elog_h */
