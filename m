Return-Path: <SRS0=wCVW=VV=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5614FC7618B
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 10:42:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 291D8229ED
	for <linux-trace-devel@archiver.kernel.org>; Wed, 24 Jul 2019 10:42:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lhvXuho3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbfGXKmH (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 24 Jul 2019 06:42:07 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39376 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbfGXKmG (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 24 Jul 2019 06:42:06 -0400
Received: by mail-wm1-f66.google.com with SMTP id u25so30792769wmc.4
        for <linux-trace-devel@vger.kernel.org>; Wed, 24 Jul 2019 03:42:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=h29dLwxD9iCVbK+mXMtsDlxHyiAPGnjqaETPWsmiaPs=;
        b=lhvXuho3VNr6S3BcoPGkoau6S22bh9MIOGIprmsNPMtD0yEu1gCY5/Wzmet9RQ+46F
         8OgV4eiVgcXZGB7zBy9hhVXrTSF4QFZnyjJ6ep8f9PDkRuCWZ2aSjgDi3Oq+kykRxtRW
         70CRaDtW2yu5VV8FlrrdpBMHCnX6VEjFjig86nCgNQWZjCfaUC2CjCYzmt+NaaWFPcit
         gy579AyZMhdkXAdAAoR1CORaRs4vZLDtbOPcEakuH26RtRY+qnQuBpqK5LgnaaYXVKAL
         jYK7PAfJNnvz1FWwvRyzCCT2DRDaI88rygN8Hf1sgpG1kBsME54/+oo75HUSyMuRNYiH
         0D0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h29dLwxD9iCVbK+mXMtsDlxHyiAPGnjqaETPWsmiaPs=;
        b=DF6gb4CmYSNfSrHBJN/o5q7utt6mHOg9xK+cdwob0liANXk8h+N3lMw+3iZbhu9gvO
         7M8VYMT5P6BwfmXzaz6QKIy8iKlc8sMp9TWI1+np1aAVub22C6HQIiipfXXCCxvsDPKu
         yXiDHX6Vh5QWkI1peq74SiqEfSfBJ2ACZ8jX0efrwfTl7dRlrohTAslFYoQw51SvSe+x
         Esqdvbxd/B57Q2chB1GqP96F/Un9o031geKvfIJ86nXEXlQCfoJypUEyQSjsK+Om6z15
         Y5i23eDZ8Pma0rtWshgJbhyQzlUUoLntqbKsBYOGhEsPZkgVEE37AsP9zCFfEcc3ObcW
         uQLQ==
X-Gm-Message-State: APjAAAVfBjdN/2xPKSF8rIfY2T4Fdm3cTyL1jVTKq5RGbJu/NeezTVWf
        whoOeu55XIBa/+Jcsu+MMiod3Rl6QpE=
X-Google-Smtp-Source: APXvYqyAz6v4SdNRd32eJluE7cOl76TXOeOtsQQC0ys3Np02tOJWhrlDIsJfdkx6wCY2e/HOptcTbA==
X-Received: by 2002:a7b:c5c2:: with SMTP id n2mr72143342wmk.92.1563964924467;
        Wed, 24 Jul 2019 03:42:04 -0700 (PDT)
Received: from [10.27.112.40] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id p6sm48707234wrq.97.2019.07.24.03.42.03
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 03:42:03 -0700 (PDT)
Subject: Re: [PATCH 2/2] kernel-shark: Set the DISPLAY environment for pkexec
 kshark-record
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
References: <20190723225044.576298160@goodmis.org>
 <20190723225238.859019956@goodmis.org>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <6658f7ac-00a3-f7fc-50f0-05be82f5ec49@gmail.com>
Date:   Wed, 24 Jul 2019 13:42:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190723225238.859019956@goodmis.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org



On 24.07.19 г. 1:50 ч., Steven Rostedt wrote:
> From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> 
> When running a fresh install, I hit this:
> 
>   ERROR:  Capture process failed:
>   Unknown errorqt.qpa.screen: QXcbConnection: Could not connect to display
>   Could not connect to any X display.
> 
> This was due to pkexec not saving the DISPLAY environment variable. To solve
> this, pass that variable as one of the environment variables to pkexec.
> 
> Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> ---
>   kernel-shark/bin/kshark-su-record | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel-shark/bin/kshark-su-record b/kernel-shark/bin/kshark-su-record
> index 7faff1cb3339..8c9fbd02a351 100755
> --- a/kernel-shark/bin/kshark-su-record
> +++ b/kernel-shark/bin/kshark-su-record
> @@ -6,4 +6,4 @@ then
>   fi
>   
>   THIS_DIR=`dirname $0`
> -pkexec ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
> +pkexec env DISPLAY=${DISPLAY} ${THIS_DIR}/kshark-record -o ${PWD}/trace.dat
> 


Both patches look good to me.
Thanks!
Yordan

Reviewed-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
