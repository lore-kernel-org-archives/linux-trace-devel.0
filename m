Return-Path: <SRS0=wXUw=2C=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2F22C43603
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 17:08:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 853AD2073B
	for <linux-trace-devel@archiver.kernel.org>; Thu, 12 Dec 2019 17:08:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="n6P5SVYw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfLLRIY (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 12 Dec 2019 12:08:24 -0500
Received: from mail-ed1-f65.google.com ([209.85.208.65]:39722 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729804AbfLLRIY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 12 Dec 2019 12:08:24 -0500
Received: by mail-ed1-f65.google.com with SMTP id v16so2415698edy.6
        for <linux-trace-devel@vger.kernel.org>; Thu, 12 Dec 2019 09:08:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Xb0zsNeEoXCLugCnhQjNYJ7KXo6z0BXbdRj+2M3VBb0=;
        b=n6P5SVYwB+bXbZeg6N4vn6hkP1jvavXhw53244Np71IQucImuXwizmDWetyVM0WpGL
         i1LaCw8ZCa2wB+vFcYm2YqCbxtCA7EVHKFV8lShyMyhck0IBGZmqOaS2nLyn8Tg5+wYe
         m5f/VMkrbFdfirnYa4yS55xlCCWyvp5li2M4u1lejvRC6Usa3skgTUIhV836TMkgJHYj
         KgbF8L75b5TKRgA91JvfoZTeimd0pfdQadBgN1jBuXDHZM//bXuDEtMcmpB3JrF2v2fD
         pvutX58jsM1U+d0udAhNlZs7+PtFT7z/oIC2UdPNF7I24qJtAM9nMjq0WWSXARzjDRwn
         z7Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Xb0zsNeEoXCLugCnhQjNYJ7KXo6z0BXbdRj+2M3VBb0=;
        b=nn750OvR6ovdTdLYVEglLM11rHmLi8IBplzYYJlVXXroQ7v+UJdS7leTMUMrzNTSJm
         KvxUazsSqygVJzQEQslk+17928DwLibQ6mYOzhqtyi2fT42qgbKGDScuGnb457U6rLJ5
         VR14zHVqTfV+UQ7Ey/QWKjCdXErtIW14mQcGb8GLCMWMt20Cgcd+JJa+2MQstrPgxmiO
         UapBu9cB7RcJ1RQ3tC1BE/tOYScl+CvcJXxDsRbSoORFA6lX5SFt9vv0rw/3z+VjELws
         4Et6+fvFhoX8u2oD1aMuOkwLmL8eiJEKOMuNIZMozVdhmCEFydn1HHxttBwJJ/tWG0Fn
         hsZA==
X-Gm-Message-State: APjAAAUwu0zo78ttPvfhXExlOsG/c+VLEnbTTopi+/esDOqNXYKO5r+0
        HUoTO5L9wpiaDBOH2xoBVhiV9yOilKgxS4B4FrP+uzAqWCVAUg==
X-Google-Smtp-Source: APXvYqwJBgIn+PaB6afGTQwbEwnj27gtmTcVIZojDBEPXa6XP/iJEnaHgA1LQ4KI5gP2R8yAbBSDT3kOFeLnCbq3mkg=
X-Received: by 2002:a17:906:785:: with SMTP id l5mr10607083ejc.311.1576170502130;
 Thu, 12 Dec 2019 09:08:22 -0800 (PST)
MIME-Version: 1.0
From:   John Koepi <john.koepi@gmail.com>
Date:   Thu, 12 Dec 2019 19:07:46 +0200
Message-ID: <CAJ8z9b0dJrkpDsU8-XWQbVVKqtocCPG+ARO4rkdboxLX_dJ2DA@mail.gmail.com>
Subject: traceevent support for kernels with CONFIG_GCC_PLUGIN_STRUCTLEAK=y
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, tz.stoyanov@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi!

In kernels built with CONFIG_GCC_PLUGIN_STRUCTLEAK=y
definition of macros __user differs from the usual one:

If __CHECKER__ is false:

> # ifdef STRUCTLEAK_PLUGIN
> #  define __user __attribute__((user))
> # else
> #  define __user
> # endif

at linux-5.4.2-arch1/include/linux/compiler_types.h:28.

It seems that this fact leads the syscalls definitions macros
linux-5.4.2-arch1/include/linux/syscalls.h

> 214:#define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
> 198:#define SYSCALL_METADATA(sname, nb, ...)
> 135:#define SYSCALL_TRACE_ENTER_EVENT(sname)

to include GGC attributes extensions definitions into the syscalls
format metadata that is then delivered to the tracefs/syscalls/format.

This gets syscalls formats to have __attribute__ inside:

> $ cat /sys/kernel/debug/tracing/events/syscalls/sys_enter_io_submit/format
> name: sys_enter_io_submit
> ID: 897
> format:
> field:unsigned short common_type; offset:0; size:2; signed:0;
> ...
> field:struct iocb __attribute__((user)) * __attribute__((user)) * iocbpp; offset:32; size:8; signed:0;
> ...

Having __attribute__ leaked into syscalls format, it makes its
impossible for the traceevent lib from the kernel/tools/lib to
parse such fields, like in the example above.

This in its turn makes it impossible to use tracing for those syscalls:

> $ sudo perf record -e syscalls:sys_enter_io_submit -aR
> libtraceevent: No such file or directory
>  Error: expected type 4 but read 5

Thus, tracing does not work for some syscalls in Arch Linux kernels.
And I suppose for all kernels that built with structleak plugin support.

Reproduce: https://github.com/sitano/traceevent_attribute

My question:

Is it a bug that the traceevent lib does not support parsing __attribute__
in syscalls formats?

or it is a bug of the SYSCALL_DEFINEx macroses / build system that
they do allow C attributes to leak?

maybe this is already fixed in the latest kernel? or maybe I am missing
something?

Thx,
Ivan
