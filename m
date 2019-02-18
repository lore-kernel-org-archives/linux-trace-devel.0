Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F98C43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 20:07:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AAA462184A
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 20:07:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727400AbfBRUHP (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:07:15 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37437 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbfBRUHP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 15:07:15 -0500
Received: by mail-wm1-f67.google.com with SMTP id x10so319492wmg.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 12:07:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RsUYz3lrJ99HeAdfqs4RHm29r5HtnKhfpRiTBR3U3ng=;
        b=SOn2POQeqkt2nfsxoB7bAq0mGvqO1li04z5zRzQVk6UbL2DRc6Aoa4I18g4M3CVe2s
         Gf4uhOHH+5oin/elTpuEaIBrbmNIo5bOcZF6PJmqE43ZW3QGqbrdI4nrhG4zocZ2OjV1
         aM7cB6mlEx7gX/6YBTvETu+ADXxT8I273QfAQIACv5fjDtlUuKUFmNLZXLDv3LZUSgKH
         089wVpN3fB9wrav0TBa21xXTOY0QgGmE1voOxtCQhZ86AXskWILctAyCX0QHshTfltX3
         dAXqDH8CjP3AenfiDLWSvPKuZbDe9KYSJAQ1AbPeBFN2ouoi/aH4MiQpK8FvjEVM2NBk
         lOCQ==
X-Gm-Message-State: AHQUAuYCUQKDO4bH9J1yHDbuGGxPQ7KyEwK0kNuyPFl7uyv49k5FctOZ
        lTskcM6R7NSHCy4118/fqQC+GWQ=
X-Google-Smtp-Source: AHgI3IYOk2f8YFX8x2bwvdrbKYTVFuZc25D3uNOgcPlVmv6fdqTuuuFU8hEbXuvHrx6c7zs9Tp/pjw==
X-Received: by 2002:a1c:c40c:: with SMTP id u12mr317392wmf.11.1550520433090;
        Mon, 18 Feb 2019 12:07:13 -0800 (PST)
Received: from box ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id n26sm200290wmk.29.2019.02.18.12.07.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 18 Feb 2019 12:07:12 -0800 (PST)
Date:   Mon, 18 Feb 2019 22:07:06 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 07/11] trace-cmd: Add `trace-cmd setup-guest`
 command
Message-ID: <20190218200705.GA5590@box>
References: <20190214141335.28144-1-kaslevs@vmware.com>
 <20190214141335.28144-8-kaslevs@vmware.com>
 <20190214154132.43082ece@gandalf.local.home>
 <20190218143746.GD11734@box>
 <20190218124437.0761e27b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190218124437.0761e27b@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Feb 18, 2019 at 12:44:37PM -0500, Steven Rostedt wrote:
> On Mon, 18 Feb 2019 16:37:47 +0200
> Slavomir Kaslev <kaslevs@vmware.com> wrote:
>
> > This won't work as proposed: `p` will be NULL on the last iteration but will
> > still get incremented from the outer for-loop and the check (p && *p) won't get
> > triggered (p == 0x01 in this case).
>
> I still don't like the "end", it just looks awkward.

If that's the only argument I don't think it stands.

>
> >
> > A fixed version might look like this:
> >
> > static int make_dir(const char *path, mode_t mode)
> > {
> > 	char buf[PATH_MAX+1], *p;
> > 	int ret = 0;
> >
> > 	strncpy(buf, path, sizeof(buf));
> > 	for (p = buf; *p; p++) {
> > 		for (; *p == '/'; p++);
> > 		p = strchr(p, '/');
> >
> > 		if (p)
> > 			*p = '\0';
> > 		ret = mkdir(buf, mode);
> > 		if (ret < 0) {
> > 			if (errno != EEXIST) {
> > 				ret = -errno;
> > 				break;
> > 			}
> > 			ret = 0;
> > 		}
> > 		if (!p)
> > 			break;
> > 		*p = '/';
> > 	}
> >
> > 	return ret;
> > }
> >
> > OTOH I find the original version much more readable:
> >
> > static int make_dir(const char *path, mode_t mode)
> > {
> > 	char buf[PATH_MAX+1], *end, *p;
> > 	int ret = 0;
> >
> > 	end = stpncpy(buf, path, sizeof(buf));
> > 	for (p = buf; p < end; p++) {
> > 		for (; p < end && *p == '/'; p++);
> > 		for (; p < end && *p != '/'; p++);
> >
> > 		*p = '\0';
> > 		ret = mkdir(buf, mode);
> > 		if (ret < 0) {
> > 			if (errno != EEXIST) {
> > 				ret = -errno;
> > 				break;
> > 			}
> > 			ret = 0;
> > 		}
> > 		*p = '/';
> > 	}
> >
> > 	return ret;
> > }
> >
> > The intent behind `*p = '\0'; ... *p = '/';` is more clearly expressed in this
> > version without getting bogged down by strchr() edge case handling.
> >
> > Since this is not on a performance critical path how about sticking to the more
> > readable of the two?
> >
>
> I'd still like to use '*p' as that's very common.

Testing for '*p' is more common since in the common case one doesn't know the
length of the string.

This is not the case here since we first do a copy anyway and hence we know the
length from then on. We also actively manipulate to string sentinel and knowing
where the string actually ends makes reasoning about the code much easier.

>
> Also break up the other for loops into a while loops.

OK switching the for()s to while()s and dropping the first `p < end` check
(which is never true) sounds fine.

>
> 	for (p = buf; *p; p++) {
>
> 		while (*p == '/')
> 			p++;
> 		while (*p && *p != '/')
> 			p++;
>
> 		if (*p)
> 			*p = '\0';
> 		else
> 			p--; /* for the for loop */
>
> 		[...]
>
>
> This would work, and I think is still readable.

It's really not more readable and having a comment explaining what's going on
only supports this claim.

That being said, I don't have strong feelings one way or another though,
disappointingly, I did want to share my bikeshedding opinion. It takes less
energy to make the proposed change than to explain why imo it's worse. If none
of the above makes any sense or you insist on dropping `end`, I'll send an
updated version of this patch for the v7 patchset tomorrow.

Thanks,

-- Slavi
