Return-Path: <SRS0=z2Pp=2X=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 198B4C3276C
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 22:44:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E094F22314
	for <linux-trace-devel@archiver.kernel.org>; Thu,  2 Jan 2020 22:44:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AADIQQKS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729589AbgABWoN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 2 Jan 2020 17:44:13 -0500
Received: from mail-ot1-f44.google.com ([209.85.210.44]:39285 "EHLO
        mail-ot1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729648AbgABWoL (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 2 Jan 2020 17:44:11 -0500
Received: by mail-ot1-f44.google.com with SMTP id 77so58836981oty.6;
        Thu, 02 Jan 2020 14:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4UPLplmo5AOYVGqcjtpqI2E26h8IabatP5llWHkVEeo=;
        b=AADIQQKSbx9mp65JscmKBxpR/0JaqscxGCSncyebyIfSDz1kdN6R6h8nbqhET796Dy
         sM6c7h4ATffbD9uCsnCu+zMwCkEd5fl9w5L5qhRMaGnoTNfJZlSkwDK1PDguSXRx4zfq
         T1R46eGsOTeSAwe2IIi5glKFv64W6gSBgOHaWthXgZxc51XBUDS46DcnDHzLiLBcJKpK
         8Xf6q+6VkEMlaBgzWipPynZ9yHP1/9m6Tv7WpQgM5MA01v4252gIwsLkqmVZBoQoRcO0
         K7jZ/jC93/aEv/DfT3eUyyGCtuId/mWMlTc+fvP3OjpJtEekLqZRo5/HJ+WITn0ipA0F
         xB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4UPLplmo5AOYVGqcjtpqI2E26h8IabatP5llWHkVEeo=;
        b=LEDy9crY7arN/2cZQOpzsYbOQyMiZvW6ZFMksDsFqOud/zcyyWNsunlxIOrrOehFQg
         a82EBYrFoWzULjDV9IRDwhNDrlPvRh5hynrmL398YrykFxpn3eukXCitlsodi0zV5Ikn
         TQudHa8uyJQ2O/LSlmV7Jh+t6HfrMMwm/aBu1fYeE0bHLp6Pnzk7AJEqRCKCgdsp9erW
         PwLGzPjc5t/zAVlcK0LJrzcQ+5NGb9KgSUzSC4PkD7aMwtpzSTvazXZpTb369Q00wUWw
         R3zkkupP36G72H90UuFUDGXkMQMybHRl6wk+GsHUna3Uyfya+X6NPBzMezq1rLxjR9hU
         abdA==
X-Gm-Message-State: APjAAAUr1NcwPAUP9UCtEuYToLFYs0R1ZBeA1RwrYbo10GlHcAGb6poJ
        t6WeHETuIAEctF8vZYfZ3U3HcZKdo+TztiFbgcw=
X-Google-Smtp-Source: APXvYqwB9iEM7ZbeZGoKl9mZU5Op4kRYRl8Y6bsc7G1ZKimVF+NO5DgS7HD7lcUOx9nfnwLJ5dxNMgDpTjqrZeKeWuc=
X-Received: by 2002:a05:6830:1e37:: with SMTP id t23mr9310819otr.16.1578005050928;
 Thu, 02 Jan 2020 14:44:10 -0800 (PST)
MIME-Version: 1.0
References: <20200102122004.216c85da@gandalf.local.home>
In-Reply-To: <20200102122004.216c85da@gandalf.local.home>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Thu, 2 Jan 2020 22:43:34 +0000
Message-ID: <CADVatmO8mvhtgZ=CNv8uxhVkh2nqg5bjCLzTxyA9UDerRox8Ug@mail.gmail.com>
Subject: Re: [RFC] tools lib traceevent: How to do library versioning being in
 the Linux kernel source?
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Jan 2, 2020 at 5:20 PM Steven Rostedt <rostedt@goodmis.org> wrote:
>
> First, I hope everyone had a Happy New Year!

Happy New Year to you too.

>
> Next, Sudip has been working to get the libtraceevent library into
> Debian. As this has been happening, I've been working at how to get all
> the projects that use this, to use the library installed on the system
> if it does exist. I'm hoping that once it's in Debian, the other
> distros will follow suit.

I have sent you another patch for libtraceevent. And, assuming that
you will not have any objection to that patch libtraceevent has been
merged in Debian and is now available in Debian Sid releases. Thanks
to Ben for all his suggestion and help.

The packages are at:
https://packages.debian.org/unstable/libtraceevent1
https://packages.debian.org/unstable/libtraceevent-dev
https://packages.debian.org/unstable/libtraceevent1-plugin


-- 
Regards
Sudip
