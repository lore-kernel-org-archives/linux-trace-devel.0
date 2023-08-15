Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5C2C001DE
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 16:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbjHOQ4Z (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 12:56:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238590AbjHOQ4A (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 12:56:00 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44CD019A7
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 09:55:59 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-790cc395896so241902339f.1
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 09:55:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692118558; x=1692723358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gxy2U982PchFqQaQB9iJkEOMUpVnlm2gW7hbdHjvAGU=;
        b=hdIHYOB23KArw0VZJwFmByOLdYsxpCogQqY0lPkl+fYkTwyl6ItLPdkue94OnvevjH
         VYl7nNucxt43yl6SGFRb3d85MyExlJLV0YEnlbKhuvSQJ2Zg0AbVFu3rTf3eWjaeumku
         Hg3VFqQRrk0JTANg7RtxV5tMXLKGpTJdODqAOk6q3J6s5iwsuSSxUZ2/KRFwP2kEtyN+
         5BC5PNu9TJuyPF6beP7Ni326E4git9rbQBAvAx+gsU9FXTV6KBlnh3nj6xJUF7Yvmaia
         2ASw/ihpD8zfmQ1AV5/qvwMs2/xY0QMBr3MDnSuTQdqquZR5bmH19Zp3QXEqhDv9OEbC
         VukQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692118558; x=1692723358;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gxy2U982PchFqQaQB9iJkEOMUpVnlm2gW7hbdHjvAGU=;
        b=QagOhykrJ7w4OaFPrd9yah36LjvW5mwwIAo2U2z5A+/WXFNY5HPanO0oIHCcgXuNK3
         31NoYJvDhcIuFuQa5Pb7erRQQrhqV7RUC5jePobwPbFRIHCkOmsItB7RGwz15YgNrALT
         QnPc1CpQCept36mpL1oCeum5urS/+1fXLDhbpOWHGbLH46GJgwDxWqEAj6MVotFX/K9C
         1llYT/e+mdvsWoPlDuxKrdXz+2W24d5o0n/PoFBVKWKBULvJWmjfRo2E2Oy5C5nHX/7P
         uX/uuER/JJA1A9syXXdENE08pTt1SaEXEQ1w2ugAnxOcg81v8K7yVcEjVwGIU+ro6xas
         +5Iw==
X-Gm-Message-State: AOJu0YxHGTFf29DJIkmfd1BhgoT1h7uzLKli/evaU7M5vEoVIEPwUIy9
        oeseHul0ZX+garVSzp/4qVjUAA==
X-Google-Smtp-Source: AGHT+IGtKNTwulqns/tPyniQWaASSIYgHntpHkI078875RHNNxz2zGpEYEUKsaj9nRnZysEvPAs1KQ==
X-Received: by 2002:a5e:d605:0:b0:787:1a8f:1d08 with SMTP id w5-20020a5ed605000000b007871a8f1d08mr15972139iom.15.1692118558459;
        Tue, 15 Aug 2023 09:55:58 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:f77a:c0d7:f137:55fe])
        by smtp.gmail.com with ESMTPSA id a26-20020a056638019a00b004290985a1efsm3788261jaq.43.2023.08.15.09.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 09:55:58 -0700 (PDT)
Date:   Tue, 15 Aug 2023 10:55:54 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 05/17] libtraceeval histograms: Add traceeval struct
 to compare function
Message-ID: <20230815165554.GB780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-6-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-6-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:28AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> When looking at how this code would be implemented, I found that I needed
> access to the traceeval structure within the compare callbacks. Pass that
> in too.
> 
> Also, rearrange the parameters a little. The traceeval and type should go
> first as they describe the "object", and the data should go last as they are
> the values of the function.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h | 13 +++++++------
>  src/histograms.c         | 19 ++++++++++---------
>  2 files changed, 17 insertions(+), 15 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 22e9029133d5..412efdbe8681 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -63,16 +63,17 @@ union traceeval_data {
>  };
>  
>  struct traceeval_type;
> +struct traceeval;
>  
>  /* struct traceeval_dynamic release function signature */
> -typedef void (*traceeval_data_release_fn)(struct traceeval_type *,
> -					  union traceeval_data *);
> +typedef void (*traceeval_data_release_fn)(const struct traceeval_type *type,
> +					  union traceeval_data *data);
>  
>  /* struct traceeval_dynamic compare function signature */
> -typedef int (*traceeval_data_cmp_fn)(const union traceeval_data *,
> -				     const union traceeval_data *,
> -				     struct traceeval_type *);
> -
> +typedef int (*traceeval_data_cmp_fn)(struct traceeval *teval,
> +				     const struct traceeval_type *type,
> +				     const union traceeval_data *A,
> +				     const union traceeval_data *B);
>  /*
>   * struct traceeval_type - Describes the type of a traceevent_data instance
>   * @type: The enum type that describes the traceeval_data
> diff --git a/src/histograms.c b/src/histograms.c
> index 09cdf57a8f6a..ece1395ac300 100644
> --- a/src/histograms.c
> +++ b/src/histograms.c
> @@ -113,7 +113,8 @@ static int compare_traceeval_type(struct traceeval_type *orig,
>   * Return 0 if @orig and @copy are the same, 1 if @orig is greater than @copy,
>   * -1 for the other way around, and -2 on error.
>   */
> -static int compare_traceeval_data(union traceeval_data *orig,
> +static int compare_traceeval_data(struct traceeval *teval,
> +				  union traceeval_data *orig,
>  				  const union traceeval_data *copy,
>  				  struct traceeval_type *type)

Nit: it would be nice if these had the same ordering as the args to
traceeval_data_cmp_fn.

Other than that you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>
