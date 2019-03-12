Return-Path: <SRS0=WSgK=RP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22D71C43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 01:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F18092084F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 12 Mar 2019 01:28:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726637AbfCLB2b (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 11 Mar 2019 21:28:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725932AbfCLB2a (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 11 Mar 2019 21:28:30 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BF922084F;
        Tue, 12 Mar 2019 01:28:26 +0000 (UTC)
Date:   Mon, 11 Mar 2019 21:28:23 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Daniel Colascione <dancol@google.com>,
        Karim Yaghmour <karim.yaghmour@opersys.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
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
        Shuah Khan <shuah@kernel.org>, Yonghong Song <yhs@fb.com>
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190311212823.60684182@oasis.local.home>
In-Reply-To: <20190312003912.GA170478@google.com>
References: <20190308140251.GC25768@kroah.com>
        <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
        <20190309071648.GE3882@kroah.com>
        <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
        <20190309121141.GA30173@kroah.com>
        <b7296377-9e0c-aed7-61f0-93d24d1ceddd@opersys.com>
        <CAMuHMdV8+XTyGf1ZJ+gMf=zQpzqh3-+b7wgi+gAmXQ6HpUAw3A@mail.gmail.com>
        <3e84e1ef-e266-e983-5874-6c26ac7f38b8@opersys.com>
        <20190311193612.4f09bf11@oasis.local.home>
        <CAKOZuetHG0O-CiO6h5tD7aht_MT70ebwWMMSPkRUHdiM3wVq0Q@mail.gmail.com>
        <20190312003912.GA170478@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 11 Mar 2019 20:39:12 -0400
Joel Fernandes <joel@joelfernandes.org> wrote:

> I think even though the kernel-headers can't have information about all data
> structures, they do already contain a lot of data structure definitions we
> need already. And anything needed can/should arguably be moved to include/ if
> they are really needed for kernel extension by something "external" to the
> kernel such as kernel modules or eBPF, right?

That's not my worry. I would like to be able to easily walk data
structures from within the kernel, without having to do a lot of work
in userspace to get that information. The kprobe_events could then be
passed type casts or such to access data fields of arguments to
functions and such.

> 
> In any case, such a solution such as what Steve suggested, still cannot do
> what we can with headers - such as build kernel modules on the fly using the
> C-compiler without any auto-generation of C code from any debug artifiacts.
> Think systemtap working with the module-backend without any need for
> linux-headers package on the file system. So such a solution would still be a
> bit orthogonal in scope to what this proposed solution can solve IMO.
> 

With the information I would like to have, it would be trivial to read
the data to create the header files needed for modules.

-- Steve
