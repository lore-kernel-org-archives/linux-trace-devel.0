Return-Path: <SRS0=lLCO=RD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39B12C43381
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 16:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1290A218B0
	for <linux-trace-devel@archiver.kernel.org>; Thu, 28 Feb 2019 16:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731398AbfB1QJV (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 28 Feb 2019 11:09:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:53198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfB1QJV (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 28 Feb 2019 11:09:21 -0500
Received: from vmware.local.home (unknown [38.88.19.130])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31DEF2184A;
        Thu, 28 Feb 2019 16:09:20 +0000 (UTC)
Date:   Thu, 28 Feb 2019 11:09:18 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, ast@kernel.org,
        atishp04@gmail.com, dancol@google.com,
        Dan Williams <dan.j.williams@intel.com>,
        Guenter Roeck <groeck@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>, karim.yaghmour@opersys.com,
        Kees Cook <keescook@chromium.org>, kernel-team@android.com,
        linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        Manoj Rao <linux@manojrajarao.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        paulmck@linux.vnet.ibm.com,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        qais.yousef@arm.com, rdunlap@infradead.org,
        Shuah Khan <shuah@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, yhs@fb.com
Subject: Re: [PATCH v3 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190228110918.06ae3346@vmware.local.home>
In-Reply-To: <20190228154513.GA12050@kroah.com>
References: <20190227193748.132301-1-joel@joelfernandes.org>
        <20190228173444.54403795211d80ba540b61cb@kernel.org>
        <20190228150054.GB156098@google.com>
        <20190228153026.GG8481@kroah.com>
        <20190228153741.GA168373@google.com>
        <20190228154513.GA12050@kroah.com>
X-Mailer: Claws Mail 3.15.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, 28 Feb 2019 16:45:13 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Feb 28, 2019 at 10:37:41AM -0500, Joel Fernandes wrote:
> > In any case, it is not practical to provide headers for every kernel version on
> > the system image and maintain them, it will take up too much space and has to
> > be periodically packaged. Not to mention that there will be kernel versions
> > that are booting Android that simply don't have anyone maintaining headers
> > for. So the proposed solution is an easier path.  
> 
> I totally agree with this, and with your proposed patches, just wanting
> to clear up some potential anti-GPL-FUD before it got spread any further :)
>

I would believe that the decision of saying it is "not allowed" is not
about it being illegal, but more of a "we would then need to keep track
of every GPL code and all the specific versions in every package that we
ship such that we will have to provide it if someone were to ask for
it", which would be required by the license. And that can be quite a
burden.

-- Steve
