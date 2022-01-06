Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AD9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 07:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235124AbiAFHCG (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 02:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234429AbiAFHCG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 02:02:06 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FBB2C061245
        for <linux-trace-devel@vger.kernel.org>; Wed,  5 Jan 2022 23:02:05 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id q5so2008079ioj.7
        for <linux-trace-devel@vger.kernel.org>; Wed, 05 Jan 2022 23:02:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvsDlgxcfQ/R1kwgYEBZAicIwglz/cP+ScMeIdW/5hM=;
        b=p1teQc3orRQ3/WEdaMOFmwX6AvtV4IoXGWWDd9+JLchubbEEb9Qaks136IT0PbI+v9
         HrFj0babR3z5+eOsT1h+eUEeFhKc/lh9k0sDEP6wJhYppk9/GK3+dZQ83RSHtMe30sia
         IzO3H/v2hOUGpl1r6+pf+vWpCj0saLvVallxn22KF1u2g1B361ogklLf+11g46Nt9WGs
         EsfHEKXeMiflrJZFxfXLQ/dvMQ12RK3SJ5RuwCITzYfqwDOM17rr3scGRzQTaNPcsa8i
         Ds0ljjshxvvmSWz7HnSdp6f3alXUavzQNBIN9QtRSZtwjrhUZ/nQFToc19o2Od/lXDgH
         0rKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvsDlgxcfQ/R1kwgYEBZAicIwglz/cP+ScMeIdW/5hM=;
        b=r8xRZTCtwb/MvG8b+qgfTj1AzOzXzOth0IV9EShSCOmRYWLfUrfL0SPZ2oS974eN3o
         URNsapCaZDEbXO6mEQcfTvAQJbkGnZ4Rx1VJZdoKtBLZFuWlJyGuUaIPZfiTlvfLvp+7
         8otJ1kGsTg6OLrXgsogAqenYEOB1F/AbHVtA5B2ku+CDQF1rMdsHovyJXZ1M+WrYc7wo
         0/HFJnMQs/qKbpx+278i5M56KtyprPrDGCJ2D6HRqj9e0SoIYSxkn1z7l+COaXJhDQu2
         ZP06EotWYgnI616FgMyqO+liwHNqBNnnolHwkZWo59We0Zv5LPFyaNBUhRNtMgA81arM
         jJYA==
X-Gm-Message-State: AOAM532AZEjkoqsK4cBJqSeKuag+cwaOWVbID0YGBXIqlEIiFt/WG8UK
        SLUqUbCjh4cwWNg2hQZCXZREOisFEADP5Rhs7WfgsQ==
X-Google-Smtp-Source: ABdhPJyaBWybR/0lru64WXfgIRiL6d8fVWv/wUbrers4AuukbshclvvreoyzcSBQcLIMNTPNm9rL0yP9sxPBfml9owc=
X-Received: by 2002:a05:6602:1484:: with SMTP id a4mr27107590iow.35.1641452524766;
 Wed, 05 Jan 2022 23:02:04 -0800 (PST)
MIME-Version: 1.0
References: <20210923001024.550263-1-irogers@google.com> <20210923001024.550263-4-irogers@google.com>
 <bc2b0786-8965-1bcd-2316-9d9bb37b9c31@kernel.org> <c19ca2a2-54c9-88b1-b705-5a2cd4dd9580@kernel.org>
 <YdMTIl7jn25XrUn8@kernel.org> <44a258b0-048d-9e32-1583-ae52aaee0a1a@kernel.org>
In-Reply-To: <44a258b0-048d-9e32-1583-ae52aaee0a1a@kernel.org>
From:   Ian Rogers <irogers@google.com>
Date:   Wed, 5 Jan 2022 23:01:52 -0800
Message-ID: <CAP-5=fWhvTCNR9Orjw4vvrrV_GV27V4rRTnym9qWaNtMdOJpjw@mail.gmail.com>
Subject: Re: [was: libtraceevent: Increase libtraceevent logging when verbose]
To:     Jiri Slaby <jirislaby@kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        eranian@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Jan 3, 2022 at 10:17 PM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> On 03. 01. 22, 16:15, Arnaldo Carvalho de Melo wrote:
> > Tried reproducing here on fedora 34 but it is at 1.1.1:
>
> FWIW, it's openSUSE Tumbleweed:
> $ rpm -q libtraceevent1
> libtraceevent1-1.3.0-1.3.x86_64

I was able to reproduce in an opensuse tumbleweed container.

$ pkg-config --modversion libtraceevent
1.3.0

$ make -C tools/perf O=/tmp/perf V=1 LIBTRACEEVENT_DYNAMIC=1
...
util/debug.c:245:34: error: 'TEP_LOG_DEBUG' undeclared (first use in
this function)
  245 |                 tep_set_loglevel(TEP_LOG_DEBUG);
      |                                  ^~~~~~~~~~~~~
util/debug.c:247:34: error: 'TEP_LOG_ALL' undeclared (first use in
this function)
  247 |                 tep_set_loglevel(TEP_LOG_ALL);
      |                                  ^~~~~~~~~~~

When I look at libtraceevent tagged as 1.3.0 I see TEP_LOG_ALL and
TEP_LOG_DEBUG:
https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git/tree/src/event-parse.h?h=libtraceevent-1.3.0#n760

and checking opensuse's event-parse.h I see the values there. This
makes it look like we're using the kernel libtraceevent header file
(version 1.1.0) rather than the system one.

The command line is:

gcc -Wp,-MD,/tmp/perf/util/.debug.o.d -Wp,-MT,/tmp/perf/util/debug.o
-Wbad-function-cast -Wdeclaration-after-statement -Wformat-security
-Wformat-y2k -Winit-self -Wmissing-declarations -Wmissing-prototypes
-Wno-system-headers -Wold-style-definition -Wpacked -Wredundant-decls
-Wstrict-prototypes -Wswitch-default -Wswitch-enum -Wundef
-Wwrite-strings -Wformat -Wno-type-limits -Wstrict-aliasing=3 -Wshadow
-DHAVE_SYSCALL_TABLE_SUPPORT -DHAVE_ARCH_X86_64_SUPPORT
-I/tmp/perf/arch/x86/include/generated -DHAVE_PERF_REGS_SUPPORT
-DHAVE_ARCH_REGS_QUERY_REGISTER_OFFSET -Werror -O6
-fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall -Wextra
-std=gnu99 -fstack-protector-all -D_FORTIFY_SOURCE=2
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
-I/kernel-src/tools/lib/perf/include
-I/kernel-src/tools/perf/util/include
-I/kernel-src/tools/perf/arch/x86/include -I/kernel-src/tools/include/
-I/kernel-src/tools/arch/x86/include/uapi
-I/kernel-src/tools/include/uapi -I/kernel-src/tools/arch/x86/include/
-I/kernel-src/tools/arch/x86/ -I/tmp/perf//util -I/tmp/perf/
-I/kernel-src/tools/perf/util -I/kernel-src/tools/perf
-I/kernel-src/tools/lib/ -DHAVE_PTHREAD_ATTR_SETAFFINITY_NP
-DHAVE_PTHREAD_BARRIER -DHAVE_EVENTFD_SUPPORT
-DHAVE_GET_CURRENT_DIR_NAME -DHAVE_GETTID -DHAVE_FILE_HANDLE
-DHAVE_GLIBC_SUPPORT -DHAVE_AIO_SUPPORT -DHAVE_SCHED_GETCPU_SUPPORT
-DHAVE_SETNS_SUPPORT -DHAVE_LIBELF_SUPPORT
-DHAVE_ELF_GETPHDRNUM_SUPPORT -DHAVE_GELF_GETNOTE_SUPPORT
-DHAVE_ELF_GETSHDRSTRNDX_SUPPORT -DHAVE_LIBBPF_SUPPORT -DHAVE_JITDUMP
-DHAVE_LIBPERL_SUPPORT -DHAVE_TIMERFD_SUPPORT -DNO_LIBPYTHON
-DNO_DEMANGLE -DHAVE_ZLIB_SUPPORT -DHAVE_BACKTRACE_SUPPORT
-DHAVE_KVM_STAT_SUPPORT -DHAVE_AUXTRACE_SUPPORT
-DLIBTRACEEVENT_VERSION=65790 -I/tmp/perf/ -D"BUILD_STR(s)=#s" -c -o
/tmp/perf/util/debug.o util/debug.c

The #include is:
#include <traceevent/event-parse.h>

The system header is at:
/usr/include/traceevent/event-parse.h
The kernel one is at /kernel-src/tools/lib/traceevent/event-parse.h.
Adding a #error to that confirms it is indeed being picked up.

Checking with:
https://gcc.gnu.org/onlinedocs/gcc/Directory-Options.html
it is true from case 3 that -I:
3. Directories specified with -I options are scanned in left-to-right order.
has priority over system:
4. Directories specified with -isystem options are scanned in
left-to-right order.
5. Standard system directories are scanned.

Which means we need to lower the priority of
/kernel-src/tools/lib/traceevent or raise the priority of
/usr/include/traceevent/. I thought I might be able to hack this with
EXTRA_CFLAGS="-I/usr/include"
but it still fails even though the -I is by my reading on the left of tools/lib:

gcc -Wp,-MD,/tmp/perf/util/.debug.o.d -Wp,-MT,/tmp/perf/util/debug.o
-I/usr/include -Wbad-function-cast -Wdeclaration-after-statement
-Wformat-security -Wformat-y2k -Winit-self -Wmissing-declarations
-Wmissing-prototypes -Wno-system-headers -Wold-style-definition
-Wpacked -Wredundant-decls -Wstrict-prototypes -Wswitch-default
-Wswitch-enum -Wundef -Wwrite-strings -Wformat -Wno-type-limits
-Wstrict-aliasing=3 -Wshadow -DHAVE_SYSCALL_TABLE_SUPPORT
-DHAVE_ARCH_X86_64_SUPPORT -I/tmp/perf/arch/x86/include/generated
-DHAVE_PERF_REGS_SUPPORT -DHAVE_ARCH_REGS_QUERY_REGISTER_OFFSET
-Werror -O6 -fno-omit-frame-pointer -ggdb3 -funwind-tables -Wall
-Wextra -std=gnu99 -fstack-protector-all -D_FORTIFY_SOURCE=2
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
-I/kernel-src/tools/lib/perf/include
-I/kernel-src/tools/perf/util/include
-I/kernel-src/tools/perf/arch/x86/include -I/kernel-src/tools/include/
-I/kernel-src/tools/arch/x86/include/uapi
-I/kernel-src/tools/include/uapi -I/kernel-src/tools/arch/x86/include/
-I/kernel-src/tools/arch/x86/ -I/tmp/perf//util -I/tmp/perf/
-I/kernel-src/tools/perf/util -I/kernel-src/tools/perf
-I/kernel-src/tools/lib/ -DHAVE_PTHREAD_ATTR_SETAFFINITY_NP
-DHAVE_PTHREAD_BARRIER -DHAVE_EVENTFD_SUPPORT
-DHAVE_GET_CURRENT_DIR_NAME -DHAVE_GETTID -DHAVE_FILE_HANDLE
-DHAVE_GLIBC_SUPPORT -DHAVE_AIO_SUPPORT -DHAVE_SCHED_GETCPU_SUPPORT
-DHAVE_SETNS_SUPPORT -DHAVE_LIBELF_SUPPORT
-DHAVE_ELF_GETPHDRNUM_SUPPORT -DHAVE_GELF_GETNOTE_SUPPORT
-DHAVE_ELF_GETSHDRSTRNDX_SUPPORT -DHAVE_LIBBPF_SUPPORT -DHAVE_JITDUMP
-DHAVE_LIBPERL_SUPPORT -DHAVE_TIMERFD_SUPPORT -DNO_LIBPYTHON
-DNO_DEMANGLE -DHAVE_ZLIB_SUPPORT -DHAVE_BACKTRACE_SUPPORT
-DHAVE_KVM_STAT_SUPPORT -DHAVE_AUXTRACE_SUPPORT
-DLIBTRACEEVENT_VERSION=65790 -I/tmp/perf/ -D"BUILD_STR(s)=#s" -c -o
/tmp/perf/util/debug.o util/debug.c

Probably some sysroot related magic. Anyway, doing this 1 line fix
solves it for me:
-----
$ git diff
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index 96ad944ca6a8..0627286380fa 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -346,7 +346,7 @@ endif

 INC_FLAGS += -I$(src-perf)/util
 INC_FLAGS += -I$(src-perf)
-INC_FLAGS += -I$(srctree)/tools/lib/
+INC_FLAGS += -idirafter$(srctree)/tools/lib/

 CORE_CFLAGS += -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
 -----

I'll send out a patch.

Sorry for the trouble. Thanks,
Ian
