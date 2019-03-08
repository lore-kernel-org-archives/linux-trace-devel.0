Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D876C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:05:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F32DD20868
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:05:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552064703;
	bh=0KmKBB5hUOmbSa2Z0IuEZtfFdYqKhcvEQl3K1X8k4/w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nCOqZBnABHoiCJVYjjvyPFcIWFBjIGOz8a8vDPsbL7FvaL9uPXBDAMjC7yMFjN86X
	 bRT1zYC2qmE0kRx/jgpXN4K2R0cauliyPQoiJKd0XXB5dCSmMDvhqvmflIhBuKlaot
	 fvLPPIqhQCyYoRB/9UNIIT8Vfhm75t3HDQeZa2Po=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbfCHRFC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:05:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:47748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfCHRFB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:05:01 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6D142146F;
        Fri,  8 Mar 2019 17:04:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552064700;
        bh=0KmKBB5hUOmbSa2Z0IuEZtfFdYqKhcvEQl3K1X8k4/w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FosBzl01qp/vRSugyk2U2vOFOjmJrmb1Pc14HKnsjkXtN/YgiYOvhpZIM9FsXShhy
         ma+sOnUx5t9VPKpw5KnFsaypJv5qEMtXUQV2sY+Iw9KlKjZakt3mUTEz85cUc8gOHg
         WEFcYFy9REp/YrJqvh0dheWDCjvPSUq4EW+xp2yA=
Date:   Fri, 8 Mar 2019 15:04:49 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Enrico Weigelt, metux IT consult" <lkml@metux.net>
Cc:     Joel Fernandes <joel@joelfernandes.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
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
Message-ID: <20190308140449.GD25768@kroah.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
 <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
 <05942dfd-b05d-0a26-f8e4-85e2a73b8feb@metux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05942dfd-b05d-0a26-f8e4-85e2a73b8feb@metux.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 08, 2019 at 02:57:24PM +0100, Enrico Weigelt, metux IT consult wrote:
> On 08.03.19 14:42, Joel Fernandes wrote:
> 
> Hi folks,
> 
> > That sounds like it could be useful. I don't see any reason off the
> > top why that would not be possible to add to the list of archived
> > files in the future. The patch allows populating the list of files
> > from Kbuild using ikh_file_list variable.
> 
> It seems the whole thing's going into a direction where a whole own
> subtopic is coming up: compressed built-in filesystem.
> 
> Haven't had a deeper thought about it yet, whether or not existing
> filesystems like squashfs, initramfs, etc are the right thing for that,
> or something new should be invented, but a generic mechanism for
> compiled-in compressed (ro) filesystems could also be interesting
> for very small devices, that perhaps even dont need any persistence.
> 
> Some requirements coming up in mind:
> 
> 1. it shall be possible to have any number of instances - possibly by
>    separate modules.
> 2. it shall be possible to use an bootloader/firmware provided image
>    (so it can serve as initrd)
> 2. data should stay compressed as long as possible, but uncompressed
>    data might be cached - do decompression on-demand
> 3. only needs to be ro (write access could be done via unionfs+friends)
> 4. it shall be swappable (if swap is enabled)
> 
> In that scenario, these in-kernel headers would just one consumer,
> I can imagine lots of others.

I too want a pony :)

Until then, I think this feature should not be bikeshedded to death.  It
fits a real need, is simple (modulo the Kbuild interactions), and is
optional for those that do not wish to waste the memory.

thanks,

greg k-h
