Return-Path: <SRS0=zcJY=QZ=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FF3AC43381
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 20:54:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53A2721479
	for <linux-trace-devel@archiver.kernel.org>; Mon, 18 Feb 2019 20:54:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729878AbfBRUyu (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 18 Feb 2019 15:54:50 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45133 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727513AbfBRUyu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 18 Feb 2019 15:54:50 -0500
Received: by mail-wr1-f67.google.com with SMTP id w17so19798157wrn.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 18 Feb 2019 12:54:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+rbBlPgsv8/TwT7U1AcCiK+fhhiXODKzIP/qx9uV1MQ=;
        b=UwsxLE+CfTTS6KG7lQuFz2S84a5ONRJbp36/nGBxL8TUFAawLrKEfkJbcbRJKQnYAX
         jg3SgdPYrgvRcPHRRkoZRumoPf5FWcJa21y+3X15ImiDxYVD3qu7YZcvD2IOHQo41AgQ
         9C6bSoyR1ou+kemXffu8++Ms2haG8rKqzTDyqUQO3ybNKZeTu9V5rkk9cDcojZXEXqw3
         1EX0dWcrACryMVTejRIusPHF95WaiiDTRUn2GEJ+0W73lKZ4bDhFuE9XOMBqDMs90332
         yyAtL/j6yjXlZMs4y6ftuBWlw9H4yyB2SwEtR62SlmQFeOUVdmfyai5oDQiUBrpf8dNk
         pZkQ==
X-Gm-Message-State: AHQUAuYnZby4gIoDWMFP2eseftelwbh75S/D6GUMqdzSH1knPxE0Apal
        JPagep++9e44sDc3baGIQg==
X-Google-Smtp-Source: AHgI3Ia+/YXgboJlsfsmp1e6HmH9BmMyKfKyjSyXjYz8GE0nIlX8yLuzlwNJCXkTGuLJgizFayNFGA==
X-Received: by 2002:a5d:4608:: with SMTP id t8mr19072836wrq.186.1550523288986;
        Mon, 18 Feb 2019 12:54:48 -0800 (PST)
Received: from box ([213.145.108.55])
        by smtp.gmail.com with ESMTPSA id z14sm7344072wrv.91.2019.02.18.12.54.47
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 18 Feb 2019 12:54:48 -0800 (PST)
Date:   Mon, 18 Feb 2019 22:54:46 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, slavomir.kaslev@gmail.com
Subject: Re: [RFC PATCH v6 07/11] trace-cmd: Add `trace-cmd setup-guest`
 command
Message-ID: <20190218205444.GB5590@box>
References: <20190214141335.28144-1-kaslevs@vmware.com>
 <20190214141335.28144-8-kaslevs@vmware.com>
 <20190214154132.43082ece@gandalf.local.home>
 <20190218143746.GD11734@box>
 <20190218124437.0761e27b@gandalf.local.home>
 <20190218200705.GA5590@box>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190218200705.GA5590@box>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, Feb 18, 2019 at 10:07:06PM +0200, Slavomir Kaslev wrote:
> On Mon, Feb 18, 2019 at 12:44:37PM -0500, Steven Rostedt wrote:
> > On Mon, 18 Feb 2019 16:37:47 +0200
> > Slavomir Kaslev <kaslevs@vmware.com> wrote:
> >
> > > This won't work as proposed: `p` will be NULL on the last iteration but will
> > > still get incremented from the outer for-loop and the check (p && *p) won't get
> > > triggered (p == 0x01 in this case).
> >
> > I still don't like the "end", it just looks awkward.
> 
> If that's the only argument I don't think it stands.
> 
> >
> > >
> > > A fixed version might look like this:
> > >
> > > static int make_dir(const char *path, mode_t mode)
> > > {
> > > 	char buf[PATH_MAX+1], *p;
> > > 	int ret = 0;
> > >
> > > 	strncpy(buf, path, sizeof(buf));
> > > 	for (p = buf; *p; p++) {
> > > 		for (; *p == '/'; p++);
> > > 		p = strchr(p, '/');
> > >
> > > 		if (p)
> > > 			*p = '\0';
> > > 		ret = mkdir(buf, mode);
> > > 		if (ret < 0) {
> > > 			if (errno != EEXIST) {
> > > 				ret = -errno;
> > > 				break;
> > > 			}
> > > 			ret = 0;
> > > 		}
> > > 		if (!p)
> > > 			break;
> > > 		*p = '/';
> > > 	}
> > >
> > > 	return ret;
> > > }
> > >
> > > OTOH I find the original version much more readable:
> > >
> > > static int make_dir(const char *path, mode_t mode)
> > > {
> > > 	char buf[PATH_MAX+1], *end, *p;
> > > 	int ret = 0;
> > >
> > > 	end = stpncpy(buf, path, sizeof(buf));
> > > 	for (p = buf; p < end; p++) {
> > > 		for (; p < end && *p == '/'; p++);
> > > 		for (; p < end && *p != '/'; p++);
> > >
> > > 		*p = '\0';
> > > 		ret = mkdir(buf, mode);
> > > 		if (ret < 0) {
> > > 			if (errno != EEXIST) {
> > > 				ret = -errno;
> > > 				break;
> > > 			}
> > > 			ret = 0;
> > > 		}
> > > 		*p = '/';
> > > 	}
> > >
> > > 	return ret;
> > > }
> > >
> > > The intent behind `*p = '\0'; ... *p = '/';` is more clearly expressed in this
> > > version without getting bogged down by strchr() edge case handling.
> > >
> > > Since this is not on a performance critical path how about sticking to the more
> > > readable of the two?
> > >
> >
> > I'd still like to use '*p' as that's very common.
> 
> Testing for '*p' is more common since in the common case one doesn't know the
> length of the string.
> 
> This is not the case here since we first do a copy anyway and hence we know the
> length from then on. We also actively manipulate to string sentinel and knowing
> where the string actually ends makes reasoning about the code much easier.
> 
> >
> > Also break up the other for loops into a while loops.
> 
> OK switching the for()s to while()s and dropping the first `p < end` check
> (which is never true) sounds fine.
> 
> >
> > 	for (p = buf; *p; p++) {
> >
> > 		while (*p == '/')
> > 			p++;
> > 		while (*p && *p != '/')
> > 			p++;
> >
> > 		if (*p)
> > 			*p = '\0';
> > 		else
> > 			p--; /* for the for loop */
> >
> > 		[...]
> >
> >
> > This would work, and I think is still readable.
> 
> It's really not more readable and having a comment explaining what's going on
> only supports this claim.
> 

I thing in the end we're comparing this:

static int make_dir(const char *path, mode_t mode)
{
	char buf[PATH_MAX+1], *end, *p;

	end = stpncpy(buf, path, sizeof(buf));
	for (p = buf; p < end; p++) {
		while (*p == '/')
			p++;
		while (p < end && *p != '/')
			p++;

		*p = '\0';
		if (mkdir(buf, mode) < 0 && errno != EEXIST)
			return -errno;
		*p = '/';
	}

	return 0;
}

to this version:

static int make_dir(const char *path, mode_t mode)
{
	char buf[PATH_MAX+1], *p;

	strncpy(buf, path, sizeof(buf));
	for (p = buf; *p; p++) {
		bool eos = true;

		while (*p == '/')
			p++;
		while (*p && *p != '/')
			p++;

		if (*p)
			*p = '\0';
		else
			eos = false;
		if (mkdir(buf, mode) < 0 && errno != EEXIST)
			return -errno;
		if (eos)
			*p = '/';
	}

	return 0;
}

Cheers,

-- Slavi
