Return-Path: <SRS0=g3Xf=24=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A96DC33C9E
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 16:59:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CA192467A
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jan 2020 16:59:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pytlvl1f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728355AbgAGQ7I (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 11:59:08 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:41275 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728235AbgAGQ7H (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 11:59:07 -0500
Received: by mail-lf1-f66.google.com with SMTP id m30so223656lfp.8
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Jan 2020 08:59:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZWRmceyPek7y4TgO3Zbk+qOLZkhPPHuP3V3EgP5a+6s=;
        b=pytlvl1fytPY9XHcagNRZSwxCth9qBFPiOZn3+PxTjaCofIcGM41I2m+2n2sPoeuEY
         Mzf+lxY7btFIIA0zJZN/6hFkLEHHcgC6wb1jBt+DFeImqH6K0KHv2yqr/GfXfOVnzDRE
         aPALvBdpx/l/FDb2ZZ0AZoCoLj/kdYpSrebVt+KJHsLiWTZeVq4J6PJ/aYpZWA2r66vA
         E9TpxtxC8J3US4LGY9rWyFV9xNzd52my6T8zve93INkqAIk2kORPcW/rXVaWpWvTLdab
         RLcHLNWB0QsK2lT3qdITkcxYm8rz5ijkAdMB0/oneOA2luB0QKcfmdNhlkow/sKt1Hr0
         zmpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZWRmceyPek7y4TgO3Zbk+qOLZkhPPHuP3V3EgP5a+6s=;
        b=nffG+UXiAwmp3Lbc+ikpmOSIkmheOeKa8EBaBski6nCneqkRB9UejrjhFVOVPxEqbW
         f3M46NdVtqLW4Rol8GDdyQ1UGUP7vmRqAFmd8hEjwY3nrphfIGDFqwMacu34r3wXw3wB
         2o6nnljh5o1HetAVuqydGMA3+mwy6gPrk6W+GzF2TQRmhaZPX/bioH+D80PdKiDQI8Sb
         XhKVABTy/S7lmW4aHGSe3y7K77MgH9tIJN4OqOeW6ceLx7H/drm17yhwVAk9OpQj0aQq
         ekKQeYWdDhD2oTPB31yrK170oF+NSlLCnSyrqlFNBjqAwVAka4GHj8/fHG6fQGbl8U/h
         a/tg==
X-Gm-Message-State: APjAAAUBC+nG7Di2isYzW8ihpGe8/8N99rV6z1UnUOSSs94swEotu6OK
        u6tjifMtCJs4ZmCqKkvC+PU=
X-Google-Smtp-Source: APXvYqw0PMamIt8EEoBoPEH9LRJvsJAzm2Tm566bjMkA3SDhR/P8gHVqbSVtIP/+qyTvr6Fg8iB52Q==
X-Received: by 2002:ac2:5498:: with SMTP id t24mr252568lfk.84.1578416345149;
        Tue, 07 Jan 2020 08:59:05 -0800 (PST)
Received: from [10.27.112.58] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id u17sm87725ljk.62.2020.01.07.08.59.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 08:59:04 -0800 (PST)
Subject: Re: [PATCH 0/5] Build trace-cruncher as Python pakage
To:     Douglas Raillard <Douglas.Raillard@arm.com>,
        "linux-trace-devel@vger.kernel.org" 
        <linux-trace-devel@vger.kernel.org>
Cc:     "rostedt@goodmis.org" <rostedt@goodmis.org>,
        Valentin Schneider <Valentin.Schneider@arm.com>,
        nd <nd@arm.com>
References: <20191212090232.24236-1-y.karadz@gmail.com>
 <AM7PR08MB5368B833EEC03246474843E08F260@AM7PR08MB5368.eurprd08.prod.outlook.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e591d041-3466-0b86-7a49-ac3fc7f1dfc7@gmail.com>
Date:   Tue, 7 Jan 2020 18:59:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <AM7PR08MB5368B833EEC03246474843E08F260@AM7PR08MB5368.eurprd08.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Douglas,

Happy new year!
Thanks a lot for trying trace-cruncher and providing us with useful 
feedback!

On 31.12.19 г. 20:37 ч., Douglas Raillard wrote:
> Hi Yordan,
> 
> Finally got around to trying trace-cruncher. I've rediscovered how much I hated C build
> systems issues in general, so here is the outcome of the first day of battle :-)
> 
> kernelshark bits:
> * kernelshark build system seems to ignore the standard CMAKE_INSTALL_PREFIX
>    but uses _INSTALL_PREFIX instead, might be worth aligning with the documented
>    standard stuff of CMake if that makes sense.
> * _INSTALL_PREFIX is used for almost everything, except a polkit file that is copied
>    to /usr/share/polkit-1 regardless of _INSTALL_PREFIX, which makes installing as
>    non root fail.
> 
> Now trace-cruncher-specific bits:
> * Building kernelshark gives shared objects with .so.X.Y.Z file names, but GCC
>    wants to link against .so
> * There are some hardcoded paths to /usr/local/ in setup.py. They don't seem
>    to break user-given include paths but it would probably be a good idea to
>    make that somewhat parametric.
> * libkshark-input.h does not seem to exist but is used by ksharkpy.c. I'm not sure
>    if I used the wrong version of something or if that's a genuine issue.
> 

I am going to send a second version of the patch-set that tries to 
address some of the problems you found. This second version of the 
patches goes a bit further and simplifies/automates the build process 
for the user. Now you only have to do:

 > make
 > sudo make install

and that's all. You also have "make clean" and "make uninstall". I hope 
this will fix the problems you reported above.

> Here is the command I used to try to build trace-cruncher in a venv with
> numpy and cython installed:
> $ pip install . --global-option=build_ext --global-option='-Itrace-cmd/install/include' --global-option='-Ltrace-cmd/install/lib/kernelshark:trace-cmd/install/lib/trace-cmd:trace-cmd/install/lib/traceevent'
> 
> I've pushed some WIP commits on top of your series on my fork if you
> want to get a look at them:
> 
> Branch: refactor
> remote: https://github.com/douglas-raillard-arm/trace-cruncher.git
> https://github.com/douglas-raillard-arm/trace-cruncher/commits/refactor
>

All new patches are available here:
https://github.com/vmware/trace-cruncher/tree/refactoring_WIP (branch 
"refactoring_WIP")

> For the sake of reproducibility until things become stable, it might be a good idea
> to maintain a WIP branch with submodules/subtrees for trace-cmd in the right version
> in trace-cruncher repo, and the series applied, so we don't have to jugle with the
> ML lore to get mbox plus other patches from the repo itself etc. Once we have that,
> we can easily include a script that calls all the build systems involved and install all the
> required bits in a venv, without polluting system-wide locations, and progressively
> turn that into a standalone setup.py (or the nearest approximation of that we
> manage to make).

In v2 I am trying to address this, partially by automating the patching 
and build of trace-cmd and partially by making all those patched 
libraries part of the package itself (exploiting some linker magic). 
However, your solution to use venv is probably by fare more common. It 
will be great if we can have some discussion here and decide which of 
the two solutions is the best.

Once again, thanks for helping us!
cheers,
Yordan

> 
> PS: apologies for the extra new lines and lack of reply markers,
> Office 365 webmail does not seem to play very nicely with plain text ...
> 
> Cheers,
> Douglas
> 
> From: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> 
> Sent: 12 December 2019 09:02
> 
> To: linux-trace-devel@vger.kernel.org <linux-trace-devel@vger.kernel.org>
> 
> Cc: rostedt@goodmis.org <rostedt@goodmis.org>; Valentin Schneider <Valentin.Schneider@arm.com>; Douglas Raillard <Douglas.Raillard@arm.com>; Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> 
> Subject: [PATCH 0/5] Build trace-cruncher as Python pakage
> 
> 
> 
> 
> This patch-set is an attempt to restructure the project and to make it
> 
> build as a native Python package. Although it looks like a complete
> 
> rewrite, this is essentially just a switching from using Cython to using
> 
> directly the C API of Python. Cython is still being used but only for
> 
> the implementation of the NumPy data wrapper. The new package has its
> 
> own stand-alone build system (very primitive for the moment) that is
> 
> completely decoupled from the existing build system used by tracecruncher.
> 
> In order to build and install the new package do:
> 
> 
> 
> sudo python setup.py install --record files.txt
> 
> 
> 
> The patch-set does not  remove the old implementation yet. This will
> 
> happen in another successive patch-set.
> 
> 
> 
> Please review as careful as possible!
> 
> 
> 
> Yordan Karadzhov (VMware) (5):
> 
>    Refactor the part of the interface that relies on libkshark
> 
>    Refactor the part of the interface that relies on libtraceevent
> 
>    Refactor NumPy based data wrapper
> 
>    Add "utils"
> 
>    Adapt the sched_wakeup.py example script to use the new tracecruncher
> 
>      module
> 
> 
> 
>   examples/sched_wakeup.py  |  30 ++---
> 
>   setup.py                  |  61 +++++++++
> 
>   src/common.h              |  20 +++
> 
>   src/datawrapper.pyx       | 201 ++++++++++++++++++++++++++++
> 
>   src/ftracepy.c            | 234 +++++++++++++++++++++++++++++++++
> 
>   src/ksharkpy.c            | 268 ++++++++++++++++++++++++++++++++++++++
> 
>   src/trace2matrix.c        |  29 +++++
> 
>   tracecruncher/__init__.py |   0
> 
>   tracecruncher/utils.py    |  54 ++++++++
> 
>   9 files changed, 882 insertions(+), 15 deletions(-)
> 
>   create mode 100644 setup.py
> 
>   create mode 100644 src/common.h
> 
>   create mode 100644 src/datawrapper.pyx
> 
>   create mode 100644 src/ftracepy.c
> 
>   create mode 100644 src/ksharkpy.c
> 
>   create mode 100644 src/trace2matrix.c
> 
>   create mode 100644 tracecruncher/__init__.py
> 
>   create mode 100644 tracecruncher/utils.py
> 
> 
> 
> --
> 
> 2.20.1
> 
> 
> 
> IMPORTANT NOTICE: The contents of this email and any attachments are confidential and may also be privileged. If you are not the intended recipient, please notify the sender immediately and do not disclose the contents to any other person, use it for any purpose, or store or copy the information in any medium. Thank you.
> 
