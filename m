Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE4AC4708E
	for <linux-trace-devel@archiver.kernel.org>; Wed,  7 Dec 2022 09:56:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiLGJ4Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 7 Dec 2022 04:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230220AbiLGJ4T (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 7 Dec 2022 04:56:19 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714A837238
        for <linux-trace-devel@vger.kernel.org>; Wed,  7 Dec 2022 01:55:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670406929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ydHD8BRF0OYag4vKXgJWfRtzblETrEX8cIPxRG7Z01w=;
        b=V91eNUaMJcOpNM1rf7DvNA87ftHW/uPZ26NLg+CISw9dD5J5BsXkjeh2yszg5PueQPX5P1
        fJSCSfbPbcabup55VLLxigzU+0AewBCGk+EGPrjH5pHHdLGYpwI6GTOT/lsnAd2Qjx/uyn
        fHAnZkseTMznBfW5tmSbOQJBG0X2yG0=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-302-nAqCnZg1NFKbW22ZLrZsiQ-1; Wed, 07 Dec 2022 04:55:28 -0500
X-MC-Unique: nAqCnZg1NFKbW22ZLrZsiQ-1
Received: by mail-wm1-f71.google.com with SMTP id c1-20020a7bc001000000b003cfe40fca79so409915wmb.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 07 Dec 2022 01:55:27 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:date:references:in-reply-to:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ydHD8BRF0OYag4vKXgJWfRtzblETrEX8cIPxRG7Z01w=;
        b=wN+nAko9xLPgyCuo13cd9urjw87em2hnt9QgeLk6nq50umsM59VjCAPyxapTJ3M7HQ
         4Qh2/zOu/lHa5tT9Zcwt4t4pzTKylc5yVKVYGCD18NYJrhB9r39xrc2VffvXfoqTol4T
         4jbIaLguURZQZdBWtm+Dn5c6yAfq1YaN5VVHFUmzqMXB2j0WWwx69vmeRFMjN4TYyKed
         8dHI+NsV6VfEnhFI2IQEX3XXbUVM8YuiqRjDR97Yl4WpjkYSnu++c5c19JTt2WC+ih1i
         Faapimfyah5jFURzOwTZcIZXNXAQfrf7Itf1xAr03tjfFDQLCsbiIw5DQUSpLG9s9oM7
         OlNw==
X-Gm-Message-State: ANoB5pmzw/9aedB373Crh4nC6b+NljmdJjUlqNZFMtqFIDgiJ4oKJuaV
        rDcNsnnGDOPfaCITMHYUoixqc/H+BsZwz8DMPxnVR4PqdX/iaYGJUTgR+QU8c7xpNpg/ON/JS+1
        Yh2Dh8jUspsS74GJnTTKsfYeQtoEjPrI=
X-Received: by 2002:a1c:7401:0:b0:3cf:934b:b7ad with SMTP id p1-20020a1c7401000000b003cf934bb7admr53106629wmc.22.1670406927074;
        Wed, 07 Dec 2022 01:55:27 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5SPRxq4xCfilzbD9uVYFkXWhX2WvupkB8+bdfJJ2A4nr55y6KWwIZvZrXktTyRQkFOV6+w6g==
X-Received: by 2002:a1c:7401:0:b0:3cf:934b:b7ad with SMTP id p1-20020a1c7401000000b003cf934bb7admr53106618wmc.22.1670406926857;
        Wed, 07 Dec 2022 01:55:26 -0800 (PST)
Received: from vschneid.remote.csb ([154.57.232.159])
        by smtp.gmail.com with ESMTPSA id o16-20020a05600c511000b003b492753826sm1218935wms.43.2022.12.07.01.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 01:55:26 -0800 (PST)
From:   Valentin Schneider <vschneid@redhat.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Daniel Bristot de Oliveira <bristot@redhat.com>,
        Clark Williams <williams@redhat.com>,
        Douglas RAILLARD <douglas.raillard@arm.com>
Subject: Re: [PATCH v2 1/2] libtraceevent: Add boiler-plate code for cpumask
 types
In-Reply-To: <20221206150813.35b5aa48@gandalf.local.home>
References: <20221116144154.3662923-1-vschneid@redhat.com>
 <20221116144154.3662923-2-vschneid@redhat.com>
 <20221206150813.35b5aa48@gandalf.local.home>
Date:   Wed, 07 Dec 2022 09:55:24 +0000
Message-ID: <xhsmh5yenpmgj.mognet@vschneid.remote.csb>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On 06/12/22 15:08, Steven Rostedt wrote:
> On Wed, 16 Nov 2022 14:41:53 +0000
> Valentin Schneider <vschneid@redhat.com> wrote:
>
>> diff --git a/include/traceevent/event-parse.h b/include/traceevent/event-parse.h
>> index f749cc2..2bb0f3e 100644
>> --- a/include/traceevent/event-parse.h
>> +++ b/include/traceevent/event-parse.h
>> @@ -242,6 +242,7 @@ enum tep_print_arg_type {
>>      TEP_PRINT_OP,
>>      TEP_PRINT_FUNC,
>>      TEP_PRINT_BITMASK,
>> +	TEP_PRINT_CPUMASK,
>>      TEP_PRINT_DYNAMIC_ARRAY_LEN,
>>      TEP_PRINT_HEX_STR,
>>  };
>
> I was about to apply this when I realized that this enum is exposed to
> applications. Any new enum must go at the end.
>

Woops, will do.

> -- Steve

