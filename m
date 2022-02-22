Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D5EC433F5
	for <linux-trace-devel@archiver.kernel.org>; Tue, 22 Feb 2022 14:25:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230059AbiBVO0E (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 22 Feb 2022 09:26:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiBVO0E (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 22 Feb 2022 09:26:04 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99E5D160FF0
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 06:25:38 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id lw4so43454937ejb.12
        for <linux-trace-devel@vger.kernel.org>; Tue, 22 Feb 2022 06:25:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MnRSV64gi83eE3DQ9o2RR6a75WUMS6wTUc4efpwhm+Q=;
        b=qaB9lfipX/xYjD0DmqF5JPhCdqs4jX9PdvIbpbI3/9+L8qx1z7VlB8JMJ7zA/0Ben4
         zqOLv0kuCj6o8WRmgqdwZcCHDGQyGhc5WgzIk00X44ftLjIqkw32ocHXi0coZ/vfdOlS
         9MC7TOOEyIJhyFUMBLEbyIIKRKoxDma0Tr0JBfd/cwSUXFuzL2gRbVvcm5fUfzvqwjnJ
         nh1NvYysvUDlNAvloiiqjK/e0GKQt79ZZD2UimR90fAlCC+PAcHypkX0Px3aQeOQdn8/
         EeJPJYk65foj/eZg4zX/S4+45vJg/KBmOv1kR4LNOIUv34npp12+5gtOkEOkoeY57lgb
         L1+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MnRSV64gi83eE3DQ9o2RR6a75WUMS6wTUc4efpwhm+Q=;
        b=MDQnyW8OWUVoXJEPbU8XA7Fyw17YQpyGfV6cFfBZ0MpZR24fjL5pOKVBaydOFSoxnv
         xcyso+/cVJBqogCxdvj8vaL73xAetBeD20wcu1dPpExG19ieZk9baJ+LJRsJgZaz66wi
         GjAOzMSMB2PwT2h2ncScNnPu1SVKJJmiXrNCCgxeSP8F/K9WOwK8kM6k1J4iv4FTXq67
         4osU7NrANZxj8jT/DIlyXTiO8duLjAcj01zn0ju/pgGsFROGxYyKZWpoZgUDrL/L94dj
         73p9gWdULy6sbg1KDl8K4vvt8Aq2ckCcm54c9o1Z/U+mCve/cZs3Yvy1slh/iwflBdvs
         XfIQ==
X-Gm-Message-State: AOAM532J+hFsqtdkmTSU0VNYXGmgUsB4NiWadOGqW1eIdEfKX2SWjlBd
        kcbliGn4B/l2S5fOIKeiCY4+ni6CFNU=
X-Google-Smtp-Source: ABdhPJzZHS810gNXB0blbP9+HdtEZp2Z6aXa9ZS0JWufzdiGWxn4CFVD7tX6m6/kuYYkJ6esoQg/jA==
X-Received: by 2002:a17:906:4c4f:b0:6ce:412:1368 with SMTP id d15-20020a1709064c4f00b006ce04121368mr19509551ejw.496.1645539937115;
        Tue, 22 Feb 2022 06:25:37 -0800 (PST)
Received: from [192.168.1.10] ([95.87.219.163])
        by smtp.gmail.com with ESMTPSA id j6sm10040401edl.98.2022.02.22.06.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 06:25:36 -0800 (PST)
Message-ID: <49f2d343-c265-6ebe-413e-c0d76e6c1cb9@gmail.com>
Date:   Tue, 22 Feb 2022 16:25:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1 1/3] libtracefs: Add user_events to libtracefs sources
Content-Language: en-US
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Beau Belgrave <beaub@linux.microsoft.com>,
        linux-trace-devel@vger.kernel.org
References: <20220218225058.12701-1-beaub@linux.microsoft.com>
 <20220218225058.12701-2-beaub@linux.microsoft.com>
 <dba49d0e-cac5-5945-e02e-b45a6d751032@gmail.com> <20220221175720.GA1738@kbox>
 <20220221141625.60a7db50@rorschach.local.home>
 <c2b27dce-96fb-176e-51b9-df6f1ce760fa@gmail.com>
 <20220222090021.3f2ba377@rorschach.local.home>
From:   Yordan Karadzhov <y.karadz@gmail.com>
In-Reply-To: <20220222090021.3f2ba377@rorschach.local.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 22.02.22 г. 16:00 ч., Steven Rostedt wrote:
> On Tue, 22 Feb 2022 08:27:31 +0200
> Yordan Karadzhov <y.karadz@gmail.com> wrote:
> 
>> I have one last question. Do you consider as a valid use case that
>> the library must support, someone to do a just 'test" without writing
>> after this, or to "write" without testing first?
> 
> Actually, that's a very good point.
> 
> I was thinking that I didn't like the "test" name, and was thinking of
> having it be:
> 
> 	if (tracefs_user_event_enabled(event)) {
> 		tracefs_user_event_record(event, ...);
> 	}
> 
> But I think you have a good point. Perhaps we should just have:
> 
> 	tracefs_user_event_trace(event, ...);
> 
> and it do all the work. But it would need to be a macro, that does:
> 
> #define tracefs_user_event_trace(event, ...)			\

I personally think that, using variadic arguments in library APIs is a not a good idea, because this enforces that the 
caller must know the number of those arguments at compile time.

For me the original solution that uses an array of items is better.
Or maybe we can have both as 2 different APIs.

Thanks!
Y.

> 	do {							\
> 		if (tracefs_user_event_enabled(event)) {	\
> 			tracefs_user_event_record(event, ##__VA_ARGS); \
> 		}						\
> 	} while (0)
> 
> Because we do not want to have the compiler process the arguments when
> the event is not enabled. That would be too much overhead.
> 
> But as a macro, it would work.
> 
> Thoughts?
> 
> -- Steve
