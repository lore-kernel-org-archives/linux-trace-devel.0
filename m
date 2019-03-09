Return-Path: <SRS0=JYjC=RM=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9776BC43381
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 12:11:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5CE5420851
	for <linux-trace-devel@archiver.kernel.org>; Sat,  9 Mar 2019 12:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552133507;
	bh=4O16E9fNDZhBtoBg6LTzReQUn4q2mpiyZ1WU4MWSeG4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=iGqy67N3YXsT/HWx/Exz3XGBa74vHLvgCpxXH8ZDOuC7SJInRAdyxF4XWORN44Kb+
	 MdyrVlmFl0nKxaWjXDiIY5o2EscvlZSA1pETfutoesX8WCUo1KwpyrRTw8NNAqwOLQ
	 kF53x8XrMoJhzqOw6u3vt968myXgZF7okNG3DINk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726450AbfCIMLq (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 9 Mar 2019 07:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726424AbfCIMLq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 9 Mar 2019 07:11:46 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83A6D207E0;
        Sat,  9 Mar 2019 12:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552133505;
        bh=4O16E9fNDZhBtoBg6LTzReQUn4q2mpiyZ1WU4MWSeG4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UstQIxdr80vytCiqdZlJVcrGphHeWcdUfexy4LUrr5GqWDjmoI7gxcY2EBTd8Nlbl
         L4WOSXka7zs6p0J1TUaV3dSE+OlroauC0wz6D820epoFGyfkSE5PwDTfkaL+hYqOUA
         kp7m+OO9z5CEvudx4enMPddudprplFXfE3r4Vr/Y=
Date:   Sat, 9 Mar 2019 13:11:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexei Starovoitov <ast@kernel.org>,
        atish patra <atishp04@gmail.com>,
        Daniel Colascione <dancol@google.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
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
Subject: Re: [PATCH v4 1/2] Provide in-kernel headers for making it easy to
 extend the kernel
Message-ID: <20190309121141.GA30173@kroah.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
 <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <20190308140251.GC25768@kroah.com>
 <CAMuHMdUmnrJtu8bBeUgtiU6y_TLHM27z1WxpPia4dXMpApeijw@mail.gmail.com>
 <20190309071648.GE3882@kroah.com>
 <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdUT+UGt9p2QhOXzAtCUmqy-a8YN-ceDa-0qANJE53pWBA@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sat, Mar 09, 2019 at 12:40:01PM +0100, Geert Uytterhoeven wrote:
> > Signing keys should be kept secure, or better yet, just deleted entirely
> > after creating and signing with them.  That's what I do for my kernels
> > and I'm pretty sure that some distros also do this.  That way there's no
> > chance that someone else can sign a module and have it loaded without
> > detection, which is what signing is supposed to prevent from happening.
> 
> If you want that kind of security, there's no point in allowing to extend the
> kernel by building more kernel modules after deployment.

That's not what these files are for (in the original user's case).  They
want these for doing tracing/ebpf stuff, which require kernel headers to
build against.

> "Raw kernel headers also cannot be copied into the filesystem like they
>  can be on other distros, due to licensing and other issues. There's no
>  linux-headers package on Android."
> 
> What's the licensing issue? What's the (legal) difference between having
> the headers on the file system, and having a kernel module including the
> headers on the file system?

There is no licensing issue, see my follow-up comment about that.

It's all in ease-of-use here.  You want to build a trace function
against a running kernel, and now you have the header files for that
specific kernel right there in the kernel itself to build against.  It
doesn't get easier than that.

thanks,

greg k-h
