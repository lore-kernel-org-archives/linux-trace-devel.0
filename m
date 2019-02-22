Return-Path: <SRS0=rw6q=Q5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6DA6C43381
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 16:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F17420665
	for <linux-trace-devel@archiver.kernel.org>; Fri, 22 Feb 2019 16:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfBVQJ0 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 22 Feb 2019 11:09:26 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53839 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbfBVQJ0 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 22 Feb 2019 11:09:26 -0500
Received: by mail-wm1-f66.google.com with SMTP id e74so2435904wmg.3
        for <linux-trace-devel@vger.kernel.org>; Fri, 22 Feb 2019 08:09:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6l+BcfMbNKGSMADETyBwVRrd4DOrxF5kP8SFfwe96W0=;
        b=XbADxHQWbk59ezDusHUge0Z+qkjP1L4OOa8Y/1r7v/jOrcmXUqXsjHMiUj63dQ7aor
         eRuLAMVYqEqk8sCvzYoeBNywKQWXWwel1MmMGBCv0b3Xm3xtvk9JTK2l0YLJwjYux4s8
         TN3h1ysTAjeF9P3MQKSvpDQRCzBRLodKxpAgFJJAPeaHAWERSGCnaMKQtjUvpbe0Jxyr
         OQJcBEnIM6AqQhuGKM0J+iU6LIVvnK3cH2KI3+4FhvnTDH8n0kKe81FH4SG8b3hY4fP7
         V4AbD27vMqRDW7NA4i4NxKyp1RT9acK7sEOhDyxChw3BNmE+chYk8aApVGFKiiZH1Ryb
         kHbQ==
X-Gm-Message-State: AHQUAuaZ9EpVsmIn3Xbggx6bAP6pfU/9+KdWkhlsk1wmUCGGNDOQ4YtL
        7/HuuxThUk8UP/mayVK+9x91b6w=
X-Google-Smtp-Source: AHgI3IYksBLRRa9X7u5tD+/0LemH2R2PdBlFC5pV+y2XG1aPJRI+1UZLa1iEkfOomFhG17sIiGV7qQ==
X-Received: by 2002:a1c:7306:: with SMTP id d6mr2881138wmb.98.1550851764287;
        Fri, 22 Feb 2019 08:09:24 -0800 (PST)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id c186sm2201592wmf.34.2019.02.22.08.09.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 22 Feb 2019 08:09:23 -0800 (PST)
Date:   Fri, 22 Feb 2019 18:09:18 +0200
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Tzvetomir Stoyanov <tstoyanov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v4 3/7] trace-cmd: Fix tracecmd_read_page_record() to
 read more than one event
Message-ID: <20190222160917.GA17098@box>
References: <20190222142836.12596-1-tstoyanov@vmware.com>
 <20190222142836.12596-4-tstoyanov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190222142836.12596-4-tstoyanov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Feb 22, 2019 at 04:28:32PM +0200, Tzvetomir Stoyanov wrote:
> The kbuffer_next_event() will return the next event on the sub buffer.
> If we pass in the last_record to tracecmd_read_page_record(), it
> initializes the sub buffer, and by calling kbuffer_next_event()
> (instead of kbuffer_read_event()), the second event on the sub buffer
> is returned. This causes the match of the last_record not to match if
> the last_record happens to be the first event on the sub buffer.
> 
> Signed-off-by: Tzvetomir Stoyanov <tstoyanov@vmware.com>
> ---
>  lib/trace-cmd/trace-input.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
> index be6720c..0a6e820 100644
> --- a/lib/trace-cmd/trace-input.c
> +++ b/lib/trace-cmd/trace-input.c
> @@ -1679,18 +1679,22 @@ tracecmd_read_page_record(struct tep_handle *pevent, void *page, int size,
>  			goto out_free;
>  		}
>  
> -		do {
> +		ptr = kbuffer_read_event(kbuf, &ts);
> +		while (ptr < last_record->data) {
>  			ptr = kbuffer_next_event(kbuf, NULL);
>  			if (!ptr)
>  				break;
> -		} while (ptr < last_record->data);

Looks good to me with a nit: the following check is not necessary

> +			if (ptr == last_record->data)
> +				break;

since the `while ()` condition above will be already false if this holds. Or am
I missing something here?

Thank you,

-- Slavi

> +		}
>  		if (ptr != last_record->data) {
>  			warning("tracecmd_read_page_record: could not find last_record");
>  			goto out_free;
>  		}
> -	}
> +		ptr = kbuffer_next_event(kbuf, &ts);
> +	} else
> +		ptr = kbuffer_read_event(kbuf, &ts);
>  
> -	ptr = kbuffer_read_event(kbuf, &ts);
>  	if (!ptr)
>  		goto out_free;
>  
> -- 
> 2.20.1
> 
