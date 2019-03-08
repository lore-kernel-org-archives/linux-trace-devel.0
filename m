Return-Path: <SRS0=Frhw=RL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.4 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7994BC43381
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:05:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4E5E22147A
	for <linux-trace-devel@archiver.kernel.org>; Fri,  8 Mar 2019 17:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552064708;
	bh=wWxR9hRaEHAVMKJhNe3opZ01U3EQ5LfT2qwcS5LBxZA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=pT1jxOOS9sWCXI+aJ3SAwxUUPi1XDYVj4WBdjmd8Svwqa+warvPQxsmfE5JLJ7/Wi
	 d9Z3WU0lJ3S1hxy9P3m6p3RhA4MRqPk/l/48FunSJG2WR9heWbHAD5sFB1DkCZIRKf
	 s0aNG7AoFb2kQb52ExarML018sWAzhZxxcB6JRL8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbfCHRE6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:04:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:47638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726286AbfCHRE6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 8 Mar 2019 12:04:58 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 285E8205F4;
        Fri,  8 Mar 2019 17:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552064697;
        bh=wWxR9hRaEHAVMKJhNe3opZ01U3EQ5LfT2qwcS5LBxZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dsIFXEPsKBgBYHpWOJ+dmybmjRZnIqzuEluYQnl3BgXlmUwXrYzY/h4jMihKH9Wmq
         RX2xmsyEa+7CBuCXxeSksWzNUUHhSkyuUFfK7BR/0qALmpJZEjU7a/SlHlV6MBpvUh
         WuzqdgupmDahhSe1icgn1kUT2KwBTjCxPbqvQ+O4=
Date:   Fri, 8 Mar 2019 15:02:51 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
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
Message-ID: <20190308140251.GC25768@kroah.com>
References: <20190301160856.129678-1-joel@joelfernandes.org>
 <CAMuHMdU77UyUs-LvRx-NN_k0Y7MZXQkBdgL2i83veCkvdzeeqA@mail.gmail.com>
 <20190307150343.GB258852@google.com>
 <CAMuHMdW_7BTZREsnz7uMTToCZ4HDOZboMJH8k8UZica2pB=Jew@mail.gmail.com>
 <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YQUcA+bnav20tAFQPXYE=epMie4X85diudKs_s-TJ7dsw@mail.gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Mar 08, 2019 at 05:42:32AM -0800, Joel Fernandes wrote:
> HI Geert,
> 
> On Fri, Mar 8, 2019, 3:53 AM Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > > It is just so much easier to use tar + xz at build time, and leave the
> > > decompression task to the user. After decompression, the files will live on
> > > the disk and the page-cache mechanism will free memory when/if the files fall
> > > off the LRUs.
> >
> > I'm also considering how generic and extensible the solution is.
> > What if people need other build artifacts in the future (e.g. signing key to
> > load signed modules)?
> 
> That sounds like it could be useful. I don't see any reason off the
> top why that would not be possible to add to the list of archived
> files in the future. The patch allows populating the list of files
> from Kbuild using ikh_file_list variable.

Um, no, you don't want the signing key in the kernel itself, as that
totally defeats the purpose of the signing key :)

greg k-h
