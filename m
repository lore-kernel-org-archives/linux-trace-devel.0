Return-Path: <SRS0=Mdk7=XS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03BCAC04EBF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 14:52:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C0ECF20578
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 14:52:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="L7Zfld4P"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440127AbfIWOw4 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 10:52:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38246 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438012AbfIWOw4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 10:52:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id j31so17496353qta.5;
        Mon, 23 Sep 2019 07:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LVRcUBek8WWbtQj9AZ/S3cOqLxD7AVaxe3HBbrsW2Ww=;
        b=L7Zfld4PTxaRgoXMLVWk6vY/Wl+ixeMhdvwKfimC7AJYgAn6M6OiPIge6hzSBFx0TU
         qMN0tia9eBrAMCxQypuV5NCH3/2M+ie+9kkinfcyb9IOrYgNP1q5wnlL6uOP78sr+sZO
         VPYpKKKrJdqyxZfipuVFb17i5TXDEqthzI75rIWHaNS0Tfrtk8+ZADdFXob9LVFuvQeV
         aXS+EEOaZcbwU47TuhiPFQ7NGulK4jBFO6dHNxLOMvn4/zgsXLOmv1+lAGVx/VQ4KSox
         cFRw0Bf0PmW3dfa8IJIr4uV2JBYZ7XclW839e+h+3N1jhH7VyTeKg5kZhA0oQEXZfukb
         T0eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=LVRcUBek8WWbtQj9AZ/S3cOqLxD7AVaxe3HBbrsW2Ww=;
        b=evHn/jzS8a6igD7Tyn6u+ZiSSRsYqv034eSzukcC3sxvuVu+oiOUK2VYtcsXOorf/y
         dvwIMoREH43Uf55HoRyo5mKtC6jGn7rNuaEiH07PhPtK6p85Dwf0HC+4IoRH7sCU1Bxr
         P7ni2+4gtgKeuuyTNE08ZyTcDVc6jzYoOflAd+ZFHQ3mQg5vD90YviRLnxfEXBq4I8fJ
         g6fZmxouwaIC38NZS7rObNVMx4GIoZ1wX7GKY1FrzR26st9gfu6t63bCphFA0W5Az8f3
         hZIyWRMF8D8P0v3wfH9GF5kwBfuMjupwLMe2lHhmiVjF4v4781LmS9KXnRUqIAoACnyG
         fL9Q==
X-Gm-Message-State: APjAAAVe5CsZqSBA8/a0BJ2J9RTYoLT4splRjBVbeFGfU5WP+mKZtOwM
        vNXtWl5wDL1WNKPlS/fEVXY=
X-Google-Smtp-Source: APXvYqzK2RfU04ZAT5aTCy6hmMAuaVPVlGVcfejHX21ZYjZDXvW52K0PCay9GoJ4f//Yb4OU2oMGnw==
X-Received: by 2002:ac8:1208:: with SMTP id x8mr337853qti.32.1569250374869;
        Mon, 23 Sep 2019 07:52:54 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id e4sm4759521qkl.135.2019.09.23.07.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 07:52:54 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id A3EB041105; Mon, 23 Sep 2019 11:52:49 -0300 (-03)
Date:   Mon, 23 Sep 2019 11:52:49 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] tools/lib/traceevent: Man page updates and some file
 movement
Message-ID: <20190923145249.GF16544@kernel.org>
References: <20190919212335.400961206@goodmis.org>
 <20190923142839.GD16544@kernel.org>
 <20190923143927.GE16544@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923143927.GE16544@kernel.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Mon, Sep 23, 2019 at 11:39:27AM -0300, Arnaldo Carvalho de Melo escreveu:
> Em Mon, Sep 23, 2019 at 11:28:39AM -0300, Arnaldo Carvalho de Melo escreveu:
> > Em Thu, Sep 19, 2019 at 05:23:35PM -0400, Steven Rostedt escreveu:
> > > Hi Arnaldo,
> > > 
> > > This is a series of man page updates to the libtraceevent code, as
> > > well as a fix to one missing prototype and some movement of the location
> > > of the plugins (to have the plugins in their own directory).
>  
> > Thanks, applied.
> 
> Its breaking the build on Ubuntu 19.04 cross building to aarch64, I'll
> see if I can fix it:

Makefiles really suck, so I'm removing this one till we get this sorted
out:

"Move traceevent plugins in its own subdirectory"

Ok?

- Arnaldo
 
> perfbuilder@9660e1237188:~$ m
> make: Entering directory '/git/perf/tools/perf'
>   BUILD:   Doing 'make -j8' parallel build
> sh: 1: command: Illegal option -c
> 
> Auto-detecting system features:
> ...                         dwarf: [ on  ]
> ...            dwarf_getlocations: [ on  ]
> ...                         glibc: [ on  ]
> ...                          gtk2: [ OFF ]
> ...                      libaudit: [ OFF ]
> ...                        libbfd: [ OFF ]
> ...                        libcap: [ OFF ]
> ...                        libelf: [ on  ]
> ...                       libnuma: [ OFF ]
> ...        numa_num_possible_cpus: [ OFF ]
> ...                       libperl: [ OFF ]
> ...                     libpython: [ OFF ]
> ...                     libcrypto: [ OFF ]
> ...                     libunwind: [ OFF ]
> ...            libdw-dwarf-unwind: [ on  ]
> ...                          zlib: [ on  ]
> ...                          lzma: [ OFF ]
> ...                     get_cpuid: [ OFF ]
> ...                           bpf: [ on  ]
> ...                        libaio: [ on  ]
> ...                       libzstd: [ OFF ]
> ...        disassembler-four-args: [ OFF ]
> 
> Makefile.config:497: No sys/sdt.h found, no SDT events are defined, please install systemtap-sdt-devel or systemtap-sdt-dev
> Makefile.config:545: No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR
> Makefile.config:637: No libcrypto.h found, disables jitted code injection, please install openssl-devel or libssl-dev
> Makefile.config:653: slang not found, disables TUI support. Please install slang-devel, libslang-dev or libslang2-dev
> Makefile.config:670: GTK2 not found, disables GTK2 support. Please install gtk2-devel or libgtk2.0-dev
> Makefile.config:697: Missing perl devel files. Disabling perl scripting support, please install perl-ExtUtils-Embed/libperl-dev
> Makefile.config:724: No python interpreter was found: disables Python support - please install python-devel/python-dev
> Makefile.config:782: No bfd.h/libbfd found, please install binutils-dev[el]/zlib-static/libiberty-dev to gain symbol demangling
> Makefile.config:813: No liblzma found, disables xz kernel module decompression, please install xz-devel/liblzma-dev
> Makefile.config:826: No libzstd found, disables trace compression, please install libzstd-dev[el] and/or set LIBZSTD_DIR
> Makefile.config:837: No libcap found, disables capability support, please install libcap-devel/libcap-dev
> Makefile.config:850: No numa.h found, disables 'perf bench numa mem' benchmark, please install numactl-devel/libnuma-devel/libnuma-dev
> Makefile.config:905: No libbabeltrace found, disables 'perf data' CTF format support, please install libbabeltrace-dev[el]/libbabeltrace-ctf-dev
> Makefile.config:931: No alternatives command found, you need to set JDIR= to point to the root of your Java directory
>   DESCEND  plugins
> make[3]: *** No rule to make target '/tmp/build/perf/libtraceevent-dynamic-list'.  Stop.
> make[2]: *** [Makefile.perf:740: /tmp/build/perf/libtraceevent-dynamic-list] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [Makefile.perf:221: sub-make] Error 2
> make: *** [Makefile:70: all] Error 2
> make: Leaving directory '/git/perf/tools/perf'
> perfbuilder@9660e1237188:~$ export
> declare -x ARCH="arm64"
> declare -x CROSS_COMPILE="aarch64-linux-gnu-"
> declare -x EXTRA_MAKE_ARGS="CORESIGHT=1"
> declare -x HOME="/home/perfbuilder"
> declare -x HOSTNAME="9660e1237188"
> declare -x OLDPWD="/"
> declare -x PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
> declare -x PWD="/home/perfbuilder"
> declare -x SHLVL="1"
> declare -x TARGET="aarch64-linux-gnu"
> declare -x TERM="xterm"
> declare -x container="podman"
> perfbuilder@9660e1237188:~$
> 
> 

-- 

- Arnaldo
