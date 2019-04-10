Return-Path: <SRS0=mbrG=SM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0691C10F11
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 19:19:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5E9420820
	for <linux-trace-devel@archiver.kernel.org>; Wed, 10 Apr 2019 19:19:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbfDJTTf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 15:19:35 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36790 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726073AbfDJTTf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 15:19:35 -0400
Received: by mail-qt1-f196.google.com with SMTP id s15so4287938qtn.3;
        Wed, 10 Apr 2019 12:19:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yg1CRWpDLdkT8DcNZ4/1Kt/Rhj0AKjem9XJsrZeWYb4=;
        b=lauKN18AGDfCEExEDyPVOa6Uh3GT+LQZQj/aeAOz7VFiWFFaOL0w+MUEUCBJHzGgil
         w/xQGaxhbSpedYNvNYUqkJomuVauywfUYmzsV0H4jqAOxB6mYU6kBaFMIK6m7QT+tU78
         IJeNJe4AQa/hR5w5gHAgvH6tZu19NVa2RXXDOmVjhajGlbpg0cl/+uJAzn9+2WsGfCuS
         AqCsmmvyJqsRTwIo4XflWg9WkFHZ5jsMLbZP3LrM2cItIZCNn0WaSdP/zq687cSQmMfN
         SCVwL0isVUQdNVZRjtTA4dS8NFJDFCUXpR+i5RICbk5/Ft+NE2Tb01XnJa+yfEBOrQAY
         yz2w==
X-Gm-Message-State: APjAAAUFzi5zPHKeWxYsd92EddTdEVlxTtmeM2DbmhBChPNb6vgsAUhU
        tYQrcPHQlnCPfmnsHMUkC3xiL2vjL9WS9wd9Yhk=
X-Google-Smtp-Source: APXvYqziMS9Y6MH6ktb8d7CS4J0XVAajtu4pUUPQPiejmRWed2wG2wYZO8+c+KHJQJataW3FJ+L3UHv8L+Bm/YeJX5o=
X-Received: by 2002:a0c:9dcb:: with SMTP id p11mr36568433qvf.28.1554923973662;
 Wed, 10 Apr 2019 12:19:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com> <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
In-Reply-To: <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 10 Apr 2019 21:19:17 +0200
Message-ID: <CAK8P3a30yY_1mPcUBxOYOkbFwoeCHbo5EHuWMN4fqKug9DiQDQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending kernel easier
To:     Olof Johansson <olof@lixom.net>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 10, 2019 at 5:09 PM Olof Johansson <olof@lixom.net> wrote:
>
> As far as format goes; there's clear precedent on cpio being used and
> supported; we already have build time requirements on the userspace
> tools with some options. Using tar would actually be a new dependency
> even if it is a common tool to have installed. With a self-populating
> FS, there's no new tool requirements on the runtime side either.

The decision between tar and cpio directly follows from whether the
headers are uncompressed in kernel space or in user space:

- we use cpio for initramfs because unpacking cpio in C code is
  fairly simple, while unpacking tar is not (see the wikipedia page on tar).
  If we were to unpack it from the kernel, the initramfs code could be
  trivially reused.
- nobody sane uses cpio in user space, since tar is already present
  almost everywhere, while cpio is rather obscure in comparison.

        Arnd
