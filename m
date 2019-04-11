Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A1B6C10F14
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 16:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C8D02133D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 16:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="ciY2xhZB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfDKQal (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 11 Apr 2019 12:30:41 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:35852 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726640AbfDKQak (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 11 Apr 2019 12:30:40 -0400
Received: by mail-pf1-f195.google.com with SMTP id z5so3713870pfn.3
        for <linux-trace-devel@vger.kernel.org>; Thu, 11 Apr 2019 09:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=yz6p7JxlGvdeQQLGjhJ9bVaviFTo9O5jKlmLBrtPSxc=;
        b=ciY2xhZBqrGVRamWEdyXZm+HVDPPv1+F+OLeHjR7pw4dh1Z2uCIqi7kX9QZ2Nw2fSe
         3ICSpeJP/1tWvICZXWQjFcCvyAiDNg/RWPWz1whH81jzBceC9pLheMqVAmvugn81KSKm
         4FTMZrgv8NDSEen6g28eGD9Axz7uKBQR2aoSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=yz6p7JxlGvdeQQLGjhJ9bVaviFTo9O5jKlmLBrtPSxc=;
        b=q6hDOoJqbL2xRT15/hvLn2ZBtJexjxjztYCu6lgNuaxK+TowlS+7Xxq+PlpdLpnImO
         SYU6JL4GkCAuRjhWnep7syIS3bLH/7TCdYqHnN0/jQ2z4yBONBuikHPS0Y2jeUrs4BRX
         njPcML5dv9SgpIShImd0OfZYI58sJOx147xnFBBrap0LoidKUZxHm1Svmwokbe3v3cTB
         A7ZsxlH+I0hIG5j7PvXde3Kh5s6sPIZ+1ebiNv+BsHelEFGcQGtzPgICF6DgRP9cGkJx
         z8cQ0XM0Ry7PimAcNvjxofer28GHjy8eVi1ojPlLXa0qwmEnAPyU2vIiJBz0ZSq/kP2E
         QGDg==
X-Gm-Message-State: APjAAAUMlwosz9AIiPWDYkRiRfM0gmt1YY0zEnhKlxvuqfneZt5MmSGv
        AhBm86hwrADe7EjEWrc/ubAutw==
X-Google-Smtp-Source: APXvYqznku4Y+edVIheLFiiF6i3mDId8Ozb9gEBivSsdoVik00tTyZSUXFIO+ELMlApiyFEVjPbdZQ==
X-Received: by 2002:aa7:82d6:: with SMTP id f22mr50947455pfn.190.1555000239933;
        Thu, 11 Apr 2019 09:30:39 -0700 (PDT)
Received: from localhost ([2620:15c:6:12:9c46:e0da:efbf:69cc])
        by smtp.gmail.com with ESMTPSA id h20sm52286114pfj.40.2019.04.11.09.30.38
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Apr 2019 09:30:38 -0700 (PDT)
Date:   Thu, 11 Apr 2019 12:30:37 -0400
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Olof Johansson <olof@lixom.net>,
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
Subject: Re: [PATCH v5 1/3] Provide in-kernel headers to make extending
 kernel easier
Message-ID: <20190411163037.GA5786@google.com>
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com>
 <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
 <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 10, 2019 at 08:15:42PM -0700, Alexei Starovoitov wrote:
> On Wed, Apr 10, 2019 at 09:34:49AM -0700, Olof Johansson wrote:
> > On Wed, Apr 10, 2019 at 8:51 AM Joel Fernandes <joelaf@google.com> wrote:
> > >
> > > On Wed, Apr 10, 2019 at 11:07 AM Olof Johansson <olof@lixom.net> wrote:
> > > [snip]
> > > > > > Wouldn't it be more convenient to provide it in a standardized format
> > > > > > such that you won't have to take an additional step, and always have
> > > > > > This is that form IMO.
> ...
> > Compared to:
> >  - Extract tarball
> >  - Build and load
> >  - Remove file tree from filesystem
> 
> I think there are too many assumptions in this thread in regard to what
> is more convenient for user space.
> I think bcc should try to avoid extracting tarball into file system.
> For example libbcc can uncompress kheader.tar.xz into virtual file system
> of clang front-end. It's more or less std::map<string, string>
> with key=path, value=content of the file. Access to such in-memory
> 'files' is obviously faster than doing open/read syscalls.
> bcc already uses this approach for some bcc internal 'files' that
> it passes to clang during compilation.
> All of /proc/kheaders.tar.xz files can be passed the same way
> without extracting them into real file system.
> 
> Joel, would be great if you can share corresponding bcc patch
> that takes advantage of /proc/kheaders

That sounds good to me. Others have tested this with BCC with a manual
extraction and setting environment variable to point BCC to the extracted
location, but I can work BCC patch that makes this automatic and share it (I
was planning to do the "automatically make BCC do it" patch for the BCC
project, but first wanted this in. But I agree with Alexei, its a good idea
to do it now and share it). Masahiro had some nits in v6 that I need to
address anyway ;-) And Olof grumbled a bit about the commit message which
could be polished a bit more :-)

thanks!

 - Joel


