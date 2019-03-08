Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E2DEC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:58:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7875820851
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 13:58:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbfCHN6g (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 08:58:36 -0500
Received: from mout.kundenserver.de ([212.227.126.135]:43301 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfCHN6g (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 08:58:36 -0500
Received: from [192.168.1.110] ([95.117.97.241]) by mrelayeu.kundenserver.de
 (mreue010 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MI5Dj-1hGEFK20Hf-00F7vX; Fri, 08 Mar 2019 14:57:29 +0100
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
To:     Joel Fernandes <joel@joelfernandes.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
 <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <05942dfd-b05d-0a26-f8e4-85e2a73b8feb@metux.net>
Date:   Fri, 8 Mar 2019 14:57:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:2vZUapQY62LzxQIv2azTdMjatX+RspFAoH+I9f/VwU+9Oy45DZw
 IdzRFwmMxw2XlX/yCTRLR3fVyw3KKVAFe2poEyG+anw49/m49tzSl29xRfbUrEWkNdLAdCS
 S3jS668IVRLDu8a34PY5hPHUcL4YfrX7x0814DEbmIvAJm6KoKXeNSQd9Zak0mHIQwZFalf
 V8yYGwbIGpiYnGsyPBiYA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ewfJ7fN90DI=:w4MjO0df0JnP1eSpJXr4RG
 QnYrYAyzLAschlet8asvYWGt/F2ygLTFRjRSF+mqh46jzfTpOhjOBTOyBLVe8zanMpvjsAy8A
 vETqngOPlPSj05RfJU7YnuniwKc5jWCXcLbmKSnOhigKpWtbn6ierlbd+apJrMxeVrXJisc6c
 0KqewOIJt/B49zl49Fl3hKs25ppthrVeZD/il+FfXnSmfS35DlcWCwR+kc8ae8CQxKcCxXGOE
 1S3PgOEkEUlMOl3bPefaK/9Z6FCNCJye5Dh9yMjIUqcMqUL9G0GfQffy3peo0+SG++Y6bD5s0
 07BYpKSDlpA5hyZW9s6XPo7aVgWyRTF2P/4qQczZSZA89HYg/4/+WhtsgM6rRerjpu3feY6o0
 93W464420Ur2s7FNVmXyk8ibsHh9cq4+Tnx/+WB8smaSbsyzHDlLpWShy3o5Gm68nrNzBoR6P
 aqx27BzXRJ3lpgalpDuZnrshWOrs77n0Xj4Fa/yRj+xSCuUXanez5puZxzQkNLQ/yIjqEZOHe
 PyO7NqNC/tbPnI5lmjN9pEcem+9Q/cikRFNqCUToZCp9SaVav2M6rHG1NUkpRPGHq3uH2c606
 NM1i4/C/1BGSxem3wJ8YKT1n7hYpzaZIUUCK0iRT86MfjPx8VodCDg5rysDT1rdO2q9ftwAt8
 UKp6Ks1qJP/m/ZZuf6jTDdPTMpV2b1RW/mR1W8CuLlSwhe/bFIQcGhQoM7hDR5kOKC6shuPWQ
 xAjMmZUyC9d1J51Fx/JIyC2+1FjJiAuNYpTL1INcwI6tgm95Cp8TPnDwQug=
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 08.03.19 14:42, Joel Fernandes wrote:

Hi folks,

> That sounds like it could be useful. I don't see any reason off the
> top why that would not be possible to add to the list of archived
> files in the future. The patch allows populating the list of files
> from Kbuild using ikh_file_list variable.

It seems the whole thing's going into a direction where a whole own
subtopic is coming up: compressed built-in filesystem.

Haven't had a deeper thought about it yet, whether or not existing
filesystems like squashfs, initramfs, etc are the right thing for that,
or something new should be invented, but a generic mechanism for
compiled-in compressed (ro) filesystems could also be interesting
for very small devices, that perhaps even dont need any persistence.

Some requirements coming up in mind:

1. it shall be possible to have any number of instances - possibly by
   separate modules.
2. it shall be possible to use an bootloader/firmware provided image
   (so it can serve as initrd)
2. data should stay compressed as long as possible, but uncompressed
   data might be cached - do decompression on-demand
3. only needs to be ro (write access could be done via unionfs+friends)
4. it shall be swappable (if swap is enabled)

In that scenario, these in-kernel headers would just one consumer,
I can imagine lots of others.


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
