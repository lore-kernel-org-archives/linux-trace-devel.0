Return-Path: <SRS0=mCQn=SN=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_NEOMUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC93FC10F11
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 03:15:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 82BB92133D
	for <linux-trace-devel@archiver.kernel.org>; Thu, 11 Apr 2019 03:15:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nlO9jVLq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbfDKDPr (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 10 Apr 2019 23:15:47 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36202 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbfDKDPq (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 10 Apr 2019 23:15:46 -0400
Received: by mail-pg1-f194.google.com with SMTP id 85so2764650pgc.3;
        Wed, 10 Apr 2019 20:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=V2a7SiMlQ8P6sQfZS+jUcSN/tLlscA3p7VdfQYPLowY=;
        b=nlO9jVLqHhncQxlUUmukEz3YnoJKI7vlao94/IogK2D1OEr3rUptNQPvGF3XWdTOlI
         fz2nRZFHfESnahdW98+MfBe8vgOKXCnWRQEtBvny2nn5VkzgO53PB6wy1Vgnr/o9QPS4
         Gp1wKNqkQfOEisD7qC+G9IRVk2D3F9CiIb2TmK8hGHEoDgf+REiXTG0tEuUUWY+PNA/4
         9ffazHCpVotMKYn8WVLvJXhdJkL6EAEImBt4gKdatWGEammb9mduQ8+4+eChvzNlWQg/
         aadLf6bScXzUDDZd0k9AvSfq3RgK9P+5OeCsSx8bKjRb+EOQB2aY1q6Ra/sBPuWncd/h
         y5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=V2a7SiMlQ8P6sQfZS+jUcSN/tLlscA3p7VdfQYPLowY=;
        b=CH4XtQ+lzLiFCqXlu+74CCzM83XyfSPn5FcvxZJWUx5m+hN8AGLwcq5JjpsQCRxXQl
         S4DefEMbFoqSUVcR0oEJBL4joVekQMOo0ufHkt6vFUmiwggSfFxHNBlpW8mKO3KO/q5e
         tixHrhNSIrsmaWARSe2ml7F7KXc9135+LjP4GbgWZQPSPuK0fel2ofnfPiskAfwXDS+w
         K690g+mftSJZ5ypLLv8ht0/pWB2+0kO4VugP2GtLVvtvFYbJ/5AupbEB2+1Yp3qbT9zI
         jmCI1srlb7mEutLs8Lwos13YtuQ2ikSmb6Pr1nQzN4sjTQ+YccZji3aAqLLjuX0DEZ1t
         FRCQ==
X-Gm-Message-State: APjAAAX51ybALmcKW9dC9lcFyatIXKEpQRT50BJmHmZ79NWrHXL8mEHb
        qakwxtXCMD1yWvfXuj/LmR4vAaaj
X-Google-Smtp-Source: APXvYqzfY3rnNZ2CdL2rT8yh6VxCvhwwMs0imLwVbfnMFS19iMppkl70xg90Q96KcWU0s2/n/D9BsA==
X-Received: by 2002:a63:4620:: with SMTP id t32mr44130049pga.363.1554952545508;
        Wed, 10 Apr 2019 20:15:45 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::e])
        by smtp.gmail.com with ESMTPSA id s19sm52184126pfe.74.2019.04.10.20.15.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 10 Apr 2019 20:15:44 -0700 (PDT)
Date:   Wed, 10 Apr 2019 20:15:42 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Olof Johansson <olof@lixom.net>
Cc:     Joel Fernandes <joelaf@google.com>,
        Joel Fernandes <joel@joelfernandes.org>,
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
Message-ID: <20190411031540.ehezr6kq7ouobpzx@ast-mbp.dhcp.thefacebook.com>
References: <20190320163116.39275-1-joel@joelfernandes.org>
 <CAOesGMheoZda84OSz9spQ7p66wot5S_9aaqaKC=QYp+8utASXA@mail.gmail.com>
 <20190408203601.GF133872@google.com>
 <CAOesGMibHCuMPCYkc8V++Z2Kuf3YQf_OjYn18GvDgzTy6ubV=g@mail.gmail.com>
 <CAJWu+or0hWce9+7aEfTHoOR8cptRbzHYVL-bPdJWGZH20dbo7Q@mail.gmail.com>
 <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMiuGK-Sbqo2z=1ab070JONav1LF82MRRLCdX-4+14_XZA@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, Apr 10, 2019 at 09:34:49AM -0700, Olof Johansson wrote:
> On Wed, Apr 10, 2019 at 8:51 AM Joel Fernandes <joelaf@google.com> wrote:
> >
> > On Wed, Apr 10, 2019 at 11:07 AM Olof Johansson <olof@lixom.net> wrote:
> > [snip]
> > > > > Wouldn't it be more convenient to provide it in a standardized format
> > > > > such that you won't have to take an additional step, and always have
> > > > > This is that form IMO.
...
> Compared to:
>  - Extract tarball
>  - Build and load
>  - Remove file tree from filesystem

I think there are too many assumptions in this thread in regard to what
is more convenient for user space.
I think bcc should try to avoid extracting tarball into file system.
For example libbcc can uncompress kheader.tar.xz into virtual file system
of clang front-end. It's more or less std::map<string, string>
with key=path, value=content of the file. Access to such in-memory
'files' is obviously faster than doing open/read syscalls.
bcc already uses this approach for some bcc internal 'files' that
it passes to clang during compilation.
All of /proc/kheaders.tar.xz files can be passed the same way
without extracting them into real file system.

Joel, would be great if you can share corresponding bcc patch
that takes advantage of /proc/kheaders

