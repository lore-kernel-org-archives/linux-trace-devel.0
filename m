Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3B12C433DB
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:07:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693AC64E79
	for <linux-trace-devel@archiver.kernel.org>; Tue,  9 Feb 2021 13:07:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhBINHN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 9 Feb 2021 08:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbhBING6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 9 Feb 2021 08:06:58 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485FBC061786
        for <linux-trace-devel@vger.kernel.org>; Tue,  9 Feb 2021 05:06:18 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id i5so3057041wmq.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 09 Feb 2021 05:06:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=HXoNX1ZxqJ6Erlvz6vwTrcOsL8NbVlFkNa03z/Nbbqw=;
        b=UtRUzrV0hefEfNm76xew9/iGk8SEskSw5QKkKH+h2hSBI21YBwMEZdvMTVfHI4zQOj
         4391ghiNYQPM09bKAmEcgstDqMfsQTfdZguZDGkI8e8RvrLu6w3bOKaVV24/2rigsw8r
         USYErn8npdMYkRnok0T5qK7rxHwGdyOh/WgzrZ+76KJtYxNWEjao9yFnhR5Epky2dnGh
         cJlxNKdy+uZ1KoAD8djTKpUoQM1ZQvUVf3+sEjeKfdDtN8G8FRSJ4nfOzPlPnz+4gmJS
         eLKJrYsbT6pnihAVBYuwWSbnoG2hEzWp1g2tGgGrhLfAxy2UH8ehgz7Gz91sQ2ar9Gd3
         mqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HXoNX1ZxqJ6Erlvz6vwTrcOsL8NbVlFkNa03z/Nbbqw=;
        b=YMUYRl5or6Jf7XqVp4gT2F+MAA0VL2qEN90omiqqIHKcpylX6S1cmkIEBXL/yamCTa
         XgdaAoLeH5pi9JZLDdSKQdhmphPvExB5mY+QR/8CoutcmNMsROrQY3TybCXAF8sZKQBd
         aen6uM/sOvgC5is0727IKepS9BZ2yppGTAIU93lZzrIHSX/AjSu6hZR65XdZcCQfqvUE
         Kz4urSAveXlO6vYt9wHcypOYZgR4Rxw+GR3tm6vDGeZLaEenO1YBqbqmGPhn5+O1873X
         WZ0q0SoottqptbmV70I+9M2TIyYHjOGU11ANGZiXhsQpERUMgFbxZO/L7/VMYWv1qU19
         16Zg==
X-Gm-Message-State: AOAM531jFWs9FuzYG8YE8SluV8Z5dolR+98RBVVmXaKW+LOxfTkWayC6
        gKn/n244SKMM4x01NcetKDGrJ4B5sLU=
X-Google-Smtp-Source: ABdhPJzXgNv9A6TEsWU7Tdc+Np1s9szpTg7dgQCTFR4DBQiV/1sVN9+2NOgJaClcdkG0+yWGGYcTuw==
X-Received: by 2002:a1c:e903:: with SMTP id q3mr3419004wmc.100.1612875976615;
        Tue, 09 Feb 2021 05:06:16 -0800 (PST)
Received: from [192.168.0.108] ([95.87.199.218])
        by smtp.gmail.com with ESMTPSA id i20sm4137995wmq.7.2021.02.09.05.06.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Feb 2021 05:06:15 -0800 (PST)
Subject: Re: Kernelshark v2 all-black plots area
To:     Dario Faggioli <dfaggioli@suse.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <ce06b82f-6335-4653-0d27-e48a37ffb5aa@gmail.com>
Date:   Tue, 9 Feb 2021 15:06:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <89dbef38a1050c31390ce263d51fff1f72a42164.camel@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Ciao Dario,

There is a bug in one of the patches from the last patch-set I sent. 
This bug was reported by Tzvetomir. My guess is that you are hitting the 
same issue. If this is the case you must also have an error message 
saying "Unable to find FreeSans font".

You can manually do the fix suggested by Tzvetomir (see his reply to 
[PATCH 15/24] kernel-shark: Update KsDualMarker and KsGLWidget) or just 
get a corrected (rebased) version of the code from
https://github.com/yordan-karadzhov/kernel-shark-v2.beta

Please let me know if this fixes your issue.
Thank you very much for testing and reporting!

Best
Yordan

On 9.02.21 г. 12:48 ч., Dario Faggioli wrote:
> Heya, me again! :-)
> 
> So, I'm not playing with trace-cmd only, I'm also giving a try to
> kernelshark-v2.
> 
> I can build it fine, and it even starts, but the plots area looks
> almost all black. The events and the tasks occurring on the "last CPU"
> (i.e., on CPU7 if I have 8 CPUs) are more or less fine, it seems
> (although still hard to work with, given the background).
> 
> Actually, it's the last plot that "works". In fact, if I add a task
> plot, I do see what that one is supposed to show, but the events of
> CPU7 disappear.
> 
> Others are there, because the marker moves if I click on the entries in
> the trace area... but they're kind of behind the black cover.
> 
> A screenshot can be found here:
> http://xenbits.xen.org/people/dariof/kernelshark-v2-black.png
> 
> Am I the only one? Can it be related to my configuration or build
> environment?
> 
> I'm happy to help with more info or try some debugging, if you think it
> could be useful.
> 
> Thanks and Regards
> 
