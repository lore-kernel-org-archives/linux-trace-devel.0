Return-Path: <SRS0=Wk/S=MR=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35533 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725952AbeJFEmQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 6 Oct 2018 00:42:16 -0400
Message-Id: <1538775697.19343.1532395120.3E626872@webmail.messagingengine.com>
From: Colin McCabe <colin@cmccabe.xyz>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
Subject: Re: [PATCH v3] tools/lib/traceevent: Replace str_error_r() with an open
 coded implementation
References: <20181002175539.2ac894c7@gandalf.local.home>
 <20181005113056.55b23c31@gandalf.local.home>
 <1538756836.4131485.1532106896.50BF1EF3@webmail.messagingengine.com>
 <20181005194716.GG20250@kernel.org>
In-Reply-To: <20181005194716.GG20250@kernel.org>
Date: Fri, 05 Oct 2018 14:41:37 -0700
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, Oct 5, 2018, at 12:47, Arnaldo Carvalho de Melo wrote:
> Em Fri, Oct 05, 2018 at 09:27:16AM -0700, Colin McCabe escreveu:
> > Hmm.  Did you consider setting the ifdefs you can set to always get the POSIX version of strerror_r?
> 
> Yes, didn't work for tools/perf, that uses _GNU_SOURCE, so we would have
> the headers with that and the .c with an explicit undef _GNU_SOURCE,
> that didn't fly, at least in my experiments, and that may be the case
> with just some odd distros, working with others.

Yeah, I believe "#undef _GNU_SOURCE" is needed.  I was including that as part of "setting [up] the ifdefs."  Sorry, that was probably confusing.

I've done the "separate .c file with POSIX strerror_r" thing before as well.  It's probably the sanest way to do things if you want to avoid the deprecation warning.

It's kind of sad that we're still having problems with strerror_r in 2018.  Someone should just use thread-local storage in glibc to fix the original strerror to work like everyone expects it to.  I have a vague memory that some OS did this (Solaris?)  The people who wouldn't want the extra 100 bytes per thread are probably embedded people using a custom libc, or people like the Golang authors who try to avoid libc altogether.

I think this also kind of happened with readdir_r.  https://lwn.net/Articles/696474/
Although in that case, it wasn't even theoretically possible to correctly use the _r version, so they had to just fix the regular one.

best,
Colin

> 
> Having a separate .c file that first thing it does is to undef
> _GNU_SOURCE, then include the necessary headers, then use strerror_r was
> what worked accross the 67 environments in my containers:
> 
>    1 alpine:3.4                    : Ok   gcc (Alpine 5.3.0) 5.3.0
>    2 alpine:3.5                    : Ok   gcc (Alpine 6.2.1) 6.2.1 
> 20160822
>    3 alpine:3.6                    : Ok   gcc (Alpine 6.3.0) 6.3.0
>    4 alpine:3.7                    : Ok   gcc (Alpine 6.4.0) 6.4.0
>    5 alpine:3.8                    : Ok   gcc (Alpine 6.4.0) 6.4.0
>    6 alpine:edge                   : Ok   gcc (Alpine 6.4.0) 6.4.0
>    7 amazonlinux:1                 : Ok   gcc (GCC) 4.8.5 20150623 (Red 
> Hat 4.8.5-28)
>    8 amazonlinux:2                 : Ok   gcc (GCC) 7.3.1 20180303 (Red 
> Hat 7.3.1-5)
>    9 android-ndk:r12b-arm          : Ok   arm-linux-androideabi-gcc 
> (GCC) 4.9.x 20150123 (prerelease)
>   10 android-ndk:r15c-arm          : Ok   arm-linux-androideabi-gcc 
> (GCC) 4.9.x 20150123 (prerelease)
>   11 centos:5                      : Ok   gcc (GCC) 4.1.2 20080704 (Red 
> Hat 4.1.2-55)
>   12 centos:6                      : Ok   gcc (GCC) 4.4.7 20120313 (Red 
> Hat 4.4.7-23)
>   13 centos:7                      : Ok   gcc (GCC) 4.8.5 20150623 (Red 
> Hat 4.8.5-28)
>   14 clearlinux:latest             : Ok   gcc (Clear Linux OS for Intel 
> Architecture) 8.2.1 20180502
>   15 debian:7                      : Ok   gcc (Debian 4.7.2-5) 4.7.2
>   16 debian:8                      : Ok   gcc (Debian 4.9.2-10+deb8u1) 
> 4.9.2
>   17 debian:9                      : Ok   gcc (Debian 6.3.0-18+deb9u1) 
> 6.3.0 20170516
>   18 debian:experimental           : Ok   gcc (Debian 8.2.0-7) 8.2.0
>   19 debian:experimental-x-arm64   : Ok   aarch64-linux-gnu-gcc (Debian 
> 8.2.0-4) 8.2.0
>   20 debian:experimental-x-mips    : Ok   mips-linux-gnu-gcc (Debian 
> 8.1.0-12) 8.1.0
>   21 debian:experimental-x-mips64  : Ok   mips64-linux-gnuabi64-gcc 
> (Debian 8.1.0-12) 8.1.0
>   22 debian:experimental-x-mipsel  : Ok   mipsel-linux-gnu-gcc (Debian 
> 8.1.0-12) 8.1.0
>   23 fedora:20                     : Ok   gcc (GCC) 4.8.3 20140911 (Red 
> Hat 4.8.3-7)
>   24 fedora:21                     : Ok   gcc (GCC) 4.9.2 20150212 (Red 
> Hat 4.9.2-6)
>   25 fedora:22                     : Ok   gcc (GCC) 5.3.1 20160406 (Red 
> Hat 5.3.1-6)
>   26 fedora:23                     : Ok   gcc (GCC) 5.3.1 20160406 (Red 
> Hat 5.3.1-6)
>   27 fedora:24                     : Ok   gcc (GCC) 6.3.1 20161221 (Red 
> Hat 6.3.1-1)
>   28 fedora:24-x-ARC-uClibc        : Ok   arc-linux-gcc (ARCompact ISA 
> Linux uClibc toolchain 2017.09-rc2) 7.1.1 20170710
>   29 fedora:25                     : Ok   gcc (GCC) 6.4.1 20170727 (Red 
> Hat 6.4.1-1)
>   30 fedora:26                     : Ok   gcc (GCC) 7.3.1 20180130 (Red 
> Hat 7.3.1-2)
>   31 fedora:27                     : Ok   gcc (GCC) 7.3.1 20180712 (Red 
> Hat 7.3.1-6)
>   32 fedora:28                     : Ok   gcc (GCC) 8.1.1 20180712 (Red 
> Hat 8.1.1-5)
>   33 fedora:rawhide                : Ok   gcc (GCC) 8.2.1 20180905 (Red 
> Hat 8.2.1-3)
>   34 gentoo-stage3-amd64:latest    : Ok   gcc (Gentoo 7.3.0-r3 p1.4) 
> 7.3.0
>   35 mageia:5                      : Ok   gcc (GCC) 4.9.2
>   36 mageia:6                      : Ok   gcc (Mageia 5.5.0-1.mga6) 
> 5.5.0
>   37 opensuse:13.2                 : Ok   gcc (SUSE Linux) 4.8.3 
> 20140627 [gcc-4_8-branch revision 212064]
>   38 opensuse:42.1                 : Ok   gcc (SUSE Linux) 4.8.5
>   39 opensuse:42.2                 : Ok   gcc (SUSE Linux) 4.8.5
>   40 opensuse:42.3                 : Ok   gcc (SUSE Linux) 4.8.5
>   41 opensuse:tumbleweed           : Ok   gcc (SUSE Linux) 7.3.1 
> 20180323 [gcc-7-branch revision 258812]
>   42 oraclelinux:6                 : Ok   gcc (GCC) 4.4.7 20120313 (Red 
> Hat 4.4.7-23.0.1)
>   43 oraclelinux:7                 : Ok   gcc (GCC) 4.8.5 20150623 (Red 
> Hat 4.8.5-28.0.1)
>   44 ubuntu:12.04.5                : Ok   gcc (Ubuntu/Linaro 4.6.3-
> 1ubuntu5) 4.6.3
>   45 ubuntu:14.04.4                : Ok   gcc (Ubuntu 4.8.4-
> 2ubuntu1~14.04.3) 4.8.4
>   46 ubuntu:14.04.4-x-linaro-arm64 : Ok   aarch64-linux-gnu-gcc (Linaro 
> GCC 5.5-2017.10) 5.5.0
>   47 ubuntu:16.04                  : Ok   gcc (Ubuntu 5.4.0-
> 6ubuntu1~16.04.10) 5.4.0 20160609
>   48 ubuntu:16.04-x-arm            : Ok   arm-linux-gnueabihf-gcc 
> (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
>   49 ubuntu:16.04-x-arm64          : Ok   aarch64-linux-gnu-gcc (Ubuntu/
> Linaro 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
>   50 ubuntu:16.04-x-powerpc        : Ok   powerpc-linux-gnu-gcc (Ubuntu 
> 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
>   51 ubuntu:16.04-x-powerpc64	   : Ok   powerpc64-linux-gnu-gcc (Ubuntu/
> IBM 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
>   52 ubuntu:16.04-x-powerpc64el    : Ok   powerpc64le-linux-gnu-gcc 
> (Ubuntu/IBM 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
>   53 ubuntu:16.04-x-s390           : Ok   s390x-linux-gnu-gcc (Ubuntu 
> 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
>   54 ubuntu:16.10                  : Ok   gcc (Ubuntu 6.2.0-5ubuntu12) 
> 6.2.0 20161005
>   55 ubuntu:17.10                  : Ok   gcc (Ubuntu 7.2.0-8ubuntu3.2) 
> 7.2.0
>   56 ubuntu:18.04                  : Ok   gcc (Ubuntu 7.3.0-16ubuntu3) 
> 7.3.0
>   57 ubuntu:18.04-x-arm            : Ok   arm-linux-gnueabihf-gcc 
> (Ubuntu/Linaro 7.3.0-16ubuntu3) 7.3.0
>   58 ubuntu:18.04-x-arm64          : Ok   aarch64-linux-gnu-gcc (Ubuntu/
> Linaro 7.3.0-16ubuntu3) 7.3.0
>   59 ubuntu:18.04-x-m68k           : Ok   m68k-linux-gnu-gcc (Ubuntu 
> 7.3.0-16ubuntu3) 7.3.0
>   60 ubuntu:18.04-x-powerpc        : Ok   powerpc-linux-gnu-gcc (Ubuntu 
> 7.3.0-16ubuntu3) 7.3.0
>   61 ubuntu:18.04-x-powerpc64	   : Ok   powerpc64-linux-gnu-gcc (Ubuntu 
> 7.3.0-16ubuntu3) 7.3.0
>   62 ubuntu:18.04-x-powerpc64el    : Ok   powerpc64le-linux-gnu-gcc 
> (Ubuntu 7.3.0-16ubuntu3) 7.3.0
>   63 ubuntu:18.04-x-riscv64        : Ok   riscv64-linux-gnu-gcc (Ubuntu 
> 7.3.0-16ubuntu3) 7.3.0
>   64 ubuntu:18.04-x-s390           : Ok   s390x-linux-gnu-gcc (Ubuntu 
> 7.3.0-16ubuntu3) 7.3.0
>   65 ubuntu:18.04-x-sh4            : Ok   sh4-linux-gnu-gcc (Ubuntu 
> 7.3.0-16ubuntu3) 7.3.0
>   66 ubuntu:18.04-x-sparc64        : Ok   sparc64-linux-gnu-gcc (Ubuntu 
> 7.3.0-16ubuntu3) 7.3.0
>   67 ubuntu:18.10                  : Ok   gcc (Ubuntu 8.2.0-4ubuntu1) 
> 8.2.0
>  
> > best,
> > Colin
> > 
> > 
> > On Fri, Oct 5, 2018, at 08:30, Steven Rostedt wrote:
> > > On Tue, 2 Oct 2018 17:55:39 -0400
> > > Steven Rostedt <rostedt@goodmis.org> wrote:
> > > 
> > > > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > > > 
> > > > While working on having PowerTop use libtracevent as a shared object
> > > > library, Tzvetomir hit "str_error_r not defined". This was added by commit
> > > > c3cec9e68f12d ("tools lib traceevent: Use str_error_r()") because
> > > > strerror_r() has two definitions, where one is GNU specific, and the other
> > > > is XSI complient. The strerror_r() is in a wrapper str_error_r() to keep the
> > > > code from having to worry about which compiler is being used.
> > > > 
> > > > The problem is that str_error_r() is external to libtraceevent, and not part
> > > > of the library. If it is used as a shared object then the tools using it
> > > > will need to define that function. I do not want that function defined in
> > > > libtraceevent itself, as it is out of scope for that library.
> > > > 
> > > > As there's only a single instance of this call, I replaced it with an open
> > > > coded algorithm that uses sys_nerr and sys_errlist error array with
> > > > strncpy() to place the error message in the given buffer. We don't need to
> > > > worry about the errors that strerror_r() returns. If the buffer isn't big
> > > > enough, we simply truncate it.
> > > > 
> > > > The sys_nerr and sys_errlist idea was found here:
> > > > 
> > > >   http://www.club.cc.cmu.edu/~cmccabe/blog_strerror.html
> > > > 
> > > > Cc: Colin Patrick McCabe <cmccabe@alumni.cmu.edu>
> > > > Reported-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> > > > Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > > > ---
> > > > Changes since v2:
> > > > 
> > > >   Use sys_nerr and sys_errlist idea.
> > > > 
> > > >  tools/lib/traceevent/event-parse.c | 9 +++++++--
> > > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > > 
> > > > diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> > > > index 7980fc6c3bac..d23d10bc5314 100644
> > > > --- a/tools/lib/traceevent/event-parse.c
> > > > +++ b/tools/lib/traceevent/event-parse.c
> > > > @@ -18,7 +18,6 @@
> > > >  #include <errno.h>
> > > >  #include <stdint.h>
> > > >  #include <limits.h>
> > > > -#include <linux/string.h>
> > > >  #include <linux/time64.h>
> > > >  
> > > >  #include <netinet/in.h>
> > > > @@ -6215,7 +6214,13 @@ int tep_strerror(struct tep_handle *pevent __maybe_unused,
> > > >  	const char *msg;
> > > >  
> > > >  	if (errnum >= 0) {
> > > > -		str_error_r(errnum, buf, buflen);
> > > > +		if (buflen > 0) {
> > > > +			if (errnum < sys_nerr)
> > > > +				strncpy(buf, sys_errlist[errnum], buflen);
> > > > +			else
> > > > +				snprintf(buf, buflen, "Unknown error %d", errnum);
> > > > +			buf[buflen - 1] = 0;
> > > > +		}
> > > 
> > > Bah, I now get warnings that sys_nerr and sys_errlist are deprecated.
> > > 
> > > OK, so going back to just using the racy strerror() should be good
> > > enough, as this incompatibility with strerror_r() is a disaster!
> > > 
> > > -- Steve
> > > 
> > > 
> > > >  		return 0;
> > > >  	}
> > > >  
> > > 
> > 
> > 
> > C.
