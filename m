Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6AB0C531DC
	for <linux-trace-devel@archiver.kernel.org>; Thu, 17 Aug 2023 19:45:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354729AbjHQTpJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 17 Aug 2023 15:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354736AbjHQTpF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 17 Aug 2023 15:45:05 -0400
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62EA4359B
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 12:45:04 -0700 (PDT)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1bbb4bde76dso41246fac.2
        for <linux-trace-devel@vger.kernel.org>; Thu, 17 Aug 2023 12:45:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692301503; x=1692906303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1Zyov34DTQseXaFYy6Pw2m7UgTmnnDS3hbh8RQeIvMo=;
        b=6hmMb4iaQ3kMSHviY+fUJIjI17fQaB1einzcr95m2OeRpIkRNS+2zDQYN0fsRH+eOo
         Mm356nB4WvwWCAlGlC800C3aWWYuRCtuS3GuIqxESHQpt+8PrRevotLM9NJ/i+NtPfHq
         vnkio1KQxwq9K/yR5nklfp+f2MzKQE4N932Xect/gCdaltLcgIY1ni0BnUAOdGrR1d6a
         A9MpM08msBrri5NvgK83tL5uZiTxHtRwKgFyDVV+CkmDG1yhKFY4+ISOLc1vPOt0xWh+
         yJmO7+OgfRI0opguaUWVdK4L0T0cm2CCpG0cMEGGKIZ6ET/1s8ZG+Hzax+hGl5J3osB3
         MMWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692301503; x=1692906303;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Zyov34DTQseXaFYy6Pw2m7UgTmnnDS3hbh8RQeIvMo=;
        b=cY/TmDxuPUcf8kgsmXTfuH05FMenMomMCRUatufUq8mhK8BjuSxGdRX5gX5TkthzW3
         8NheFzM+CLg8P1U+7VN2ick5sWfnHlMyXitYQN0wlNhJTg9Igd/OP8gYxefwD9AapfOF
         EvUCwpaBlUCah/ER9I+x2zHoJFKl1G6843UStsN+/Bllpvh7rB5ijyegYduWRsxea2SL
         ze37+Q5nRdadffszRynE8Ls1h6OI7uYrbBjH7TFD+7RNzbsE1tGP7QA9i0kU/iknnnbO
         sCT0TZedcfLHtBuuSCW1GwTKjs1Zghvt3L+JZJDPFx1IYp/O6y9RhXzw8eneWaedElf8
         5A8Q==
X-Gm-Message-State: AOJu0Yw+zZKTbd0o3Iohs0VUC4MP0mrMrc7Janpfg8L6QEUNpDQF3Ecv
        EGdgc3k+BIzc1VhoXpFx4bdiGA==
X-Google-Smtp-Source: AGHT+IEdogvwKIxs20qz/AxCSP3TeGX/UwqlwJBI6yPmg+VItd2PSRlaMUfeIENSkhbQr4gula8D+Q==
X-Received: by 2002:a05:6871:202:b0:1b0:408a:1d05 with SMTP id t2-20020a056871020200b001b0408a1d05mr464647oad.38.1692301503310;
        Thu, 17 Aug 2023 12:45:03 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:b4cc:633b:f35:be2e])
        by smtp.gmail.com with ESMTPSA id dx5-20020a0566381d0500b0042bb6431487sm42418jab.65.2023.08.17.12.45.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Aug 2023 12:45:02 -0700 (PDT)
Date:   Thu, 17 Aug 2023 13:44:59 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v3 14/18] libtraceeval histogram: Use stack for old copy
 in update
Message-ID: <20230817194459.GB73817@google.com>
References: <20230817013310.88582-1-rostedt@goodmis.org>
 <20230817013310.88582-15-rostedt@goodmis.org>
 <20230817192926.GA73817@google.com>
 <20230817154245.26b014e6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817154245.26b014e6@gandalf.local.home>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Aug 17, 2023 at 03:42:45PM -0400, Steven Rostedt wrote:
> On Thu, 17 Aug 2023 13:29:26 -0600
> Ross Zwisler <zwisler@google.com> wrote:
> 
> > > + fail:
> > > +	/* Free the new values that were added */
> > > +	data_release(i, copy, types);
> > > +	/* Put back the old values */
> > > +	for (i--; i >= 0; i--) {
> > > +		copy_traceeval_data(types + i, NULL,
> > > +				    copy + i, old + i);  
> > 
> > should be:                          old + i, copy + i);
> > 
> > Right now we're copying 'copy' into 'old', but we want to be doing it the
> > other way around so we restore 'copy' back to its saved state in 'old'
> 
> I need to change the parameter names to "src" and "dst" as I can't think of
> "orig" and "copy" as which direction they go. 

I was thinking the same thing, 'src' and 'dst' would be better. :)

> I looked at that three times,
> and still am confused. And probably reverse them too to make it equivalent
> to memcpy():
> 
> From memcpy() man page;
> 
> SYNOPSIS
>        #include <string.h>
> 
>        void *memcpy(void *restrict dest, const void *restrict src, size_t n);
> 
> DESCRIPTION
>        The memcpy() function copies n bytes from memory area src to memory
>        area dest.  The memory areas must not overlap.  Use memmove(3) if
>        the memory areas do overlap.
> 
> As most standard libraries have it "dst, src" I'm pretty much thinking that
> way, and my "direction" is always dst = src --> dst, src. And that's
> exactly what I was thinking above :-p
> 
> -- Steve
> 
