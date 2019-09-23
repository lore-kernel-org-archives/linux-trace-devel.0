Return-Path: <SRS0=Mdk7=XS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 819C1C04EBF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 14:24:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5694620820
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 14:24:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YNPFCoeX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437853AbfIWOYd (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 10:24:33 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:42654 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437634AbfIWOYc (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 10:24:32 -0400
Received: by mail-qk1-f195.google.com with SMTP id f16so15563787qkl.9;
        Mon, 23 Sep 2019 07:24:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vk0/OPhAn9qSdGb1WjStJEJ0RI7wDUEmmnJKVAT8PFE=;
        b=YNPFCoeXv3p79zxdrGOMvcvxSNph9yGKSwUD34fECrfocx+iJxPJGBV08aqV/95hrf
         VSWlJD9d4xXHLJikQSvsI3nXgPQCbrADao1qlWA27Rer1Yqis4FvHrTPZMVBNIN3yZ89
         keJCJqi0fFemYbDx8OhH6Tf4URRbhMqlZOboDOM0ph1sZ/O76AaevEYvy8hm2ZOb5HKS
         k17MgtQIwpv8NfJMpMUVDzSyP1KtHIM9os1zzNKKnX3k9QWKNBoNmX9NHiz9T5/HwweC
         eelh2eau3e28wnbPb84a3j9EV+84znHuoazPtKYx+bc/oXxQgv9orW+GkJREHcvzo2sW
         6QCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Vk0/OPhAn9qSdGb1WjStJEJ0RI7wDUEmmnJKVAT8PFE=;
        b=fgc04a3QIPNcAJmFsBtFV2YU/TO7aoi604/pL3idJT9L/yfrEYeMPQFA10fhrfAA+1
         Jgxe5FbtdxjLhRIChTUJMa3lTsbxxU+c6tfAEZwl4iJLGm6wfj15RJm4afFWyo8qL8a1
         nBDCTygldyii0WkS2x+SCSYZgFhEAXNwcq9iYGOeuQn2j42Kz28SjvxqEYjE5O5ICdYS
         D0Ibg8tKHrg6VDWkNkDjIaT5DJF2fWfbY9B5YFyDADWxScRpFsHfkTotqzXYCs4wIKE6
         M+5T8tpzRxBTMw5E9j63/NkQ1xYkF79ld0sjvtUn+g1KQSk/DhLzn5IXwhLiz8EBVMXX
         Q7yA==
X-Gm-Message-State: APjAAAX4oOS9AOJL3UMgxX84V+2qAodxzG/nKmlcA6j/jpTHxredERXb
        tnUh422msa5LVfJCjj4m7Rk=
X-Google-Smtp-Source: APXvYqyNHTdI+q+y0PWlv8ZQ+HBzxwLtkaDRxrKNic79Wh2WYksDv0tdNSV5ru6eSDac51Mqm3UVAQ==
X-Received: by 2002:a37:f61e:: with SMTP id y30mr67166qkj.208.1569248671656;
        Mon, 23 Sep 2019 07:24:31 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id k54sm6492234qtf.28.2019.09.23.07.24.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 07:24:30 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 2A8AA41105; Mon, 23 Sep 2019 11:24:28 -0300 (-03)
Date:   Mon, 23 Sep 2019 11:24:28 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Tzvetomir Stoyanov <tstoyanov@vmware.com>
Subject: Re: [PATCH] tools/lib/traceevent: Round up in tep_print_event() time
 precision
Message-ID: <20190923142428.GC16544@kernel.org>
References: <20190919165119.5efa5de6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919165119.5efa5de6@gandalf.local.home>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Sep 19, 2019 at 04:51:19PM -0400, Steven Rostedt escreveu:
> 
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> 
> When testing the output of the old trace-cmd compared to the one that uses
> the updated tep_print_event() logic, it was different in that the time stamp
> precision in the old format would round up to the nearest precision, where
> as the new logic truncates. Bring back the old method of rounding up.

Thanks, applied.

- Arnaldo
 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>  tools/lib/traceevent/event-parse.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index bb22238debfe..eb84fbb49e4d 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -5517,8 +5517,10 @@ static void print_event_time(struct tep_handle *tep, struct trace_seq *s,
>  	if (divstr && isdigit(*(divstr + 1)))
>  		div = atoi(divstr + 1);
>  	time = record->ts;
> -	if (div)
> +	if (div) {
> +		time += div / 2;
>  		time /= div;
> +	}
>  	pr = prec;
>  	while (pr--)
>  		p10 *= 10;
> -- 
> 2.20.1

-- 

- Arnaldo
