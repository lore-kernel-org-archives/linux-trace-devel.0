Return-Path: <SRS0=jb6J=WC=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EDEFC433FF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 06:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 25AB12086D
	for <linux-trace-devel@archiver.kernel.org>; Tue,  6 Aug 2019 06:07:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CK2fsGw1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731641AbfHFGHg (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 6 Aug 2019 02:07:36 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:45505 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731560AbfHFGHf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Aug 2019 02:07:35 -0400
Received: by mail-pl1-f196.google.com with SMTP id y8so37421673plr.12
        for <linux-trace-devel@vger.kernel.org>; Mon, 05 Aug 2019 23:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=x0F4dbeHdzWD172Jhg3Hq9qul4MaqzojzgDhO8nTJSY=;
        b=CK2fsGw1YfNgvtf2YDP7R0tAfYQp9Xvm8OV2n9JVK0iexjVo9qK95jrhnYNdb8YssA
         eBD4OXnckuD/G2jBWNUBzvQxYlQoOCK0+jd7NZ9DU24O0dOhV7yg7SSMPZdd7hkv+aSz
         csheCoTOcxJJgMqh878GB3Axd8c8AtQ+PkI26iaeroRtk5RJNi1rQtqcmXG12bDd186A
         Cr6CHkfdxBscDfVtjvCMOzvj5VfsceeRf/hpGolYdMzSEOWdXJ1k8jNigRomtEBAzli4
         7zFlbvGaMLbxsQRJ1Gs0wLlZq78TJsqxFj6KgZXIvPwsKyYqE/7ZaT1U2j/0J+Pu9HUq
         2S/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=x0F4dbeHdzWD172Jhg3Hq9qul4MaqzojzgDhO8nTJSY=;
        b=Vf6mIoq+n0+xQFDOgB5OorkJdAbANUb7lrhOZU3U/2Jy+bNENHtn/NDY0ndeLNQO56
         ei0UcBOTUmXaDCGWzgIYSJMDMhzQS1BUm7m8nS+1DrC8SJjuWso3/BUqxMbc3BngR7HI
         xr7ixCkAudSRZWLLHhAacsshdYEc8nDqOrlpjZoEMWLbCotwy2Igc3Hvl24Qruly0Q/l
         CM2zCCYl949GiVyo6zjRbBOG2PGOPNR/yn0umcj6Ey1MyImTXD8N5MC79Lt6Q48xeTtA
         vH4FMresxIu+k1zEYlgvmsnYUHexAROQAY3gIKum2OyhT8rMFRJI2bkpJzXhnW44twG6
         VhmQ==
X-Gm-Message-State: APjAAAWyiZTPtNez5JNOCQrugoqjzUJOVwRjR4JxjmcOUDljCxE09sPk
        LFgKpitJu81BJp8iH0BL3C8=
X-Google-Smtp-Source: APXvYqzUxqI7kDAR199iRE57J2Sk/oksO9Ws66laNABNeh4lWxGLyRU1+JuVrnrlslaWPEgCi3jnNg==
X-Received: by 2002:a17:902:4201:: with SMTP id g1mr1510635pld.300.1565071655181;
        Mon, 05 Aug 2019 23:07:35 -0700 (PDT)
Received: from localhost ([175.223.3.169])
        by smtp.gmail.com with ESMTPSA id l44sm16774161pje.29.2019.08.05.23.07.33
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 05 Aug 2019 23:07:34 -0700 (PDT)
Date:   Tue, 6 Aug 2019 15:07:30 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Subject: Re: [PATCH 1/2] parse-events: deref pointer for proper sizeof()
Message-ID: <20190806060730.GB16977@jagdpanzerIV>
References: <20190805102646.31142-1-sergey.senozhatsky@gmail.com>
 <20190805232103.04c6ad28@oasis.local.home>
 <20190806051418.GB851@jagdpanzerIV>
 <20190806054115.GA16977@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190806054115.GA16977@jagdpanzerIV>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On (08/06/19 14:41), Sergey Senozhatsky wrote:
> 
> This patch seems to do the trick for me.
> 

D'oh...

Steven, please scratch all these patches which I have sent.
Something terribly wrong happened on my box and git didn't pull
the current master properly yesterday. Somehow. No sure I understand
how, tho. I looked at very outdated source code tree.

Sorry for the noise!!

	-ss
