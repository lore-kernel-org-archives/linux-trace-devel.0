Return-Path: <SRS0=k/vv=SO=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E6E9C10F14
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 16:17:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE14E21872
	for <linux-trace-devel@archiver.kernel.org>; Fri, 12 Apr 2019 16:17:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfDLQRd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 12 Apr 2019 12:17:33 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:48793 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726624AbfDLQRd (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Apr 2019 12:17:33 -0400
Received: from [192.168.1.110] ([77.9.22.14]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1MlfCm-1gXMZn2zqc-00ihOT; Fri, 12 Apr 2019 18:16:25 +0200
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel
 easier
To:     Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Qais Yousef <qais.yousef@arm.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Manoj Rao <linux@manojrajarao.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Kees Cook <keescook@chromium.org>,
        Android Kernel Team <kernel-team@android.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        linux-trace-devel@vger.kernel.org,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com>
 <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAK8P3a30yY_1mPcUBxOYOkbFwoeCHbo5EHuWMN4fqKug9DiQDQ@mail.gmail.com>
From:   "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Organization: metux IT consult
Message-ID: <76db9a89-ae64-5c2b-6f56-3e2b860cbda2@metux.net>
Date:   Fri, 12 Apr 2019 18:16:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAK8P3a30yY_1mPcUBxOYOkbFwoeCHbo5EHuWMN4fqKug9DiQDQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:dWetcqOfu10Yc5D6lS4VyXUoAG9WgPFH9RDc2jKVVoXU1gJ+5P8
 MBaUYQMk6VlFIOTX0e6SXCElIpyN44mMd+I29mpzBfS6LbSHfTWfnB7qGSUSUuBVR4rMe57
 QWuzRW7j5dqTuhLQCx26arGX5K1SMUU9Oz2FjxuaGwi/6H2M7Sz0s9O5ceQUkWAk9KU6B1w
 UPlGW6QzOWErJln+1NCWQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:OJXk5PcjVLo=:Uxwf6otcekeXPVs+AqoKvz
 Pp9R7ihPRH9mMxHeHvPc/aZjRKZObGTl9XqeYDcKq6UaZvkEPflpkLa8C/ZlquC7rwQcBuOHa
 ToAlT8d2/rREGxyUgEsknNhrt7h7/j+jKPJ29HZhs6Y1GnVj9IOFQJBF34xnGaKr/9vqe2GNH
 8ZcBCBQwjLSPihKeyQul+1oYmG+bSNynkM+AWcVgH8zTmjFa5YDfOC4nIh9PoR1+rqd/YhYvP
 pwvUE4EJBYQnp+0Xr8ORNPrJiVXvYiaCcSkolVwgUelNBciiCufsF7cXUjKsx5snB8lYIHQWu
 ejbSFJsESeP0KuU28FEW0DL7kTEwO/9SaU0ELOZrZcGanpoBKY/FRY0GXDqoSebB30+lDfTwR
 ePqu38Q6Wh1WmLxRK/KzIkO06NtKc2M2fO3PLQD/Q/0TRvSk5b1WFT6ru8dRuX6Hsl2SiPRqz
 TW3XMQZuXbT9HrIUbItT0Y0Ycdcf6/y4xBDvrOMcGLhGcpeJq9uAKNHxxTEEe/Vnbc69gKyL5
 8kw8BROHsT7Y8wAv/fdX3z4h2wtk5spgf3rNLlrnG2A7wb3nuESyGShC0nUIgRMKr6nRYCg6Y
 GmFTjTfQm/YbDhnY+5HPH2plCzT5cABosPO8933ojpdmJIVyLQmDOm4AfFCNIY+OY8KiulGpq
 mRppk0ftrChqqn3Vgy8yzAqWnGepGfvFN01x9HD6/8oyCTnpckK320HylHo/YJ45NflzH/GR6
 XSgAtOX3hWAE1CjhHG6LOTdAyJbWTNEehAL1gmQhABLBhMKVtZ5Y/pNefdI=
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 10.04.19 21:19, Arnd Bergmann wrote:

> - we use cpio for initramfs because unpacking cpio in C code is
>   fairly simple, while unpacking tar is not (see the wikipedia page on tar).
>   If we were to unpack it from the kernel, the initramfs code could be
>   trivially reused.

What about ar ? ;-)

> - nobody sane uses cpio in user space, since tar is already present
>   almost everywhere, while cpio is rather obscure in comparison.

So, rpm doesn't count as "sane" ? :o


--mtx

-- 
Enrico Weigelt, metux IT consult
Free software and Linux embedded engineering
info@metux.net -- +49-151-27565287
