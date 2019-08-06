Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36B52C31E40
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 13:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04E0020C01
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 13:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aEu07eWq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731664AbfHFNf2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 09:35:28 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:38894 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbfHFNf2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 09:35:28 -0400
Received: by mail-pf1-f193.google.com with SMTP id y15so41541909pfn.5
        for <linux-trace-devel@vger.kernel.org>; Tue, 06 Aug 2019 06:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BRGCFZSd4uFPOqgLDxjKgwFsjRB+AaLq7Z10tehHOBE=;
        b=aEu07eWqyKB1Ww8C6t8r57TRBx699nlTNv9aHVD95JNLEFvfizxiJSEedqvW7FG0I1
         dUtcpmVnZQrOOTOLkUNjw8oBFuZK49CGlrMymmT7jd/TWrZDSGzwSxZIBxeQc86HHtPp
         749fX9swxfT6b79AaYKGbUNtBGhVIqHTfzhjaqfgDIY4VlxQrfQKHq8tJeJXm52abeOg
         AUqgS3LZSFcETRIe/2Dc2GnARKHvk1Mua5ggJ+HnriGhgvZliHRt1VvSAUs6FW6fbkUf
         KxRlWLWgsHogaogogjpO5xWBbend0TSNUgEJH2/xs1IgtMUD+gopKkLWfvGNsJoyW/gI
         7Izw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BRGCFZSd4uFPOqgLDxjKgwFsjRB+AaLq7Z10tehHOBE=;
        b=T6pJ1/cR5T6JMEqb+VCIk4F9Hvf0pbdHRRm2GghUvLMSSgwo3WNpRLSNKdmNhy/YN1
         lU7yWLzX3svntVefcPMO2+A1/ewbHQrO3K0sitKgBU4VXGP0zIUSTGUVFtgZaJjy0hIC
         5THSednqXpqVhiw73o3IHq4JDwlEUPf2orB9TrRBq2Y6VLOUlfQ/nDsjxZUNkq/dYOgL
         N32vFdI6OZEWt+W/DnCQ8nBaF45Z3cTkarPo4oCKYoEFBxmRHFW9wyVVjXDcpvf78IGp
         lepf8vQazoQGiBS+MRQpNWkRfwyXhzTGl2It9HHokplAfxN36Of4hGzXiVoeLPDfunep
         XIWA==
X-Gm-Message-State: APjAAAWV5CzJg2QF81FuCafij7jCd+Fln3YbABh0YmfqfXNrEW5Zz+sl
        TXzvg9Iq5sLMcXY0pp/cdfI=
X-Google-Smtp-Source: APXvYqz8w+CDraU5b7B1+B7agoFFtg5Lzd0NB9zngksY9a6e9Fla4GTBroqYzxBXzWcB4Pl3LvzKHw==
X-Received: by 2002:aa7:957c:: with SMTP id x28mr3753928pfq.42.1565098527590;
        Tue, 06 Aug 2019 06:35:27 -0700 (PDT)
Received: from localhost ([121.137.63.184])
        by smtp.gmail.com with ESMTPSA id x22sm94341388pff.5.2019.08.06.06.35.26
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 06:35:26 -0700 (PDT)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Tue, 6 Aug 2019 22:35:23 +0900
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: Re: [PATCH 0/2] [RFC] several build fixes
Message-ID: <20190806133523.GA16932@tigerII.localdomain>
References: <20190806055950.23842-1-sergey.senozhatsky@gmail.com>
 <20190806092702.31e62a83@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806092702.31e62a83@gandalf.local.home>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On (08/06/19 09:27), Steven Rostedt wrote:
> > Hi,
> > 
> > 	RFC
> > 
> > These patches fix v1.1.1 build on my system.
> > 
> 
> Hi Sergey,
> 
> v1.1.1 is 8 years old and no longer supported.
> 
> Care to use the latest code? Otherwise, you'll need to simply maintain
> these changes locally.

Hi Steven,

Nah, was just some weird fault on my side. A very weird one. Never mind
those patches; I did git pull but it took 24h to realize that git pull
didn't work out and I was still looking at commits from 2011. I was like
"hold on a second, no way Steven would ever let this happen" and then I
checked the repository state... Which I cloned in 2011, yes.

My apologies!

	-ss
