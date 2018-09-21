Return-Path: <SRS0=4N8R=MD=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727392AbeIUTKP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 21 Sep 2018 15:10:15 -0400
Date: Fri, 21 Sep 2018 09:21:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tzvetomir Stoyanov <tzvmware@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: power top libtraceevent integration
Message-ID: <20180921092122.114b3779@gandalf.local.home>
In-Reply-To: <CACqStoeTGfJJUL2bm55Te3GBUmS1RoSshTHvPtrTkpegF--5Tg@mail.gmail.com>
References: <CACqStoeTGfJJUL2bm55Te3GBUmS1RoSshTHvPtrTkpegF--5Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 21 Sep 2018 14:04:14 +0300
Tzvetomir Stoyanov <tzvmware@gmail.com> wrote:

> Hello Steven,
> I started to work on power top integration with the traceevent
> library, most of this is already completed. There are few issues,
> which I'm not sure how to resolve and need an advice:
>   1. Problem with the undefined reference to str_error_r(). As I see,
> it is implemented in tools/lib/str_error_r.c and is not part of the
> traceevent library. How we should handle this ? We can reimplement
> str_error_r() as part of the library, using "__attribute__((weak))",
> but this solution will not be portable. Or we can get rid of this
> function, is it a must to use it ?

No, let's remove it from libtraceevent. I'll do this upstream, as it
might be a touchy subject.


>   2. In order to be used by autoconfig, the library requires
> integration with pkg-config framework. We must prepare and install
> relevant .pc file. I think we should do it in trace-cmd tree, and not
> in linux kernel tree.

Hmm, I'm not to familiar with how pkg-config and autoconfig work (I've
tried to avoid them ;-) For now we can just work with it in the
trace-cmd repo, but it's going to eventually need to be part of the
kernel, as that's where the library will come from.

-- Steve
