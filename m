Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E1B7C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 16:51:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbjHOQvC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 12:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234132AbjHOQue (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 12:50:34 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D2A83
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 09:50:33 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-349099fce6dso23959045ab.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 09:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692118232; x=1692723032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tDJaParexKFPoPPxKOBljHU5u3jKNjD4Hy+NNNzYoKE=;
        b=7hgUM7u1A9N1DfuJXKx8ZN+2q5zcDlXVDV/LAbuP0S7dt5fUIXB5Z9IS8uS6k7qPXL
         pBfi1IQaRk70BPG7DCVOt3+u9X/VT/2T1mOS3hJonkMtwjKlcxXVgM3bzI1C+z57oOAE
         5nB8XWqJ6ScSPeUnA3Ed6EXSsl3XyuphXsUBAhpvIKU+Lpk9v4+JxkoQexF7+8ec++CO
         772ze9cPp9FbI8ydqiw6wHZ5RLFdnzvQPqllI/1NJU4CXGgY0vxSwSuet/DOoEEoRS1b
         HiDqwumQYF1JcTZZMD4M/vwnL4VjEQI33cMtb+0wZA0g5MVY6T8bFG74xj+ofLdEV0ek
         jCmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692118232; x=1692723032;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tDJaParexKFPoPPxKOBljHU5u3jKNjD4Hy+NNNzYoKE=;
        b=j1/FHQmSBZiKvovH0eYh2xwdAKPK074evRW9niA/dbXlEj7dT1Fo9+Iyu7gFPPkUB0
         32f3qDtVblWxQBio3pdXOT1ourQT44SYdL9+D+oPdNDspoLlA9ChfRjDp8AXalM9OBC6
         BuoRTNzFU30q5yZ9KYZGSvidMxMe+s1HiCQzw//0052Hioj0jMuLQPB97DHmxbWM9kXS
         2VgEns7d9ZmMfaoLv/cwdcA4TWtrQ+NNQqbWHczOzCFSuA6gy3r2l5h5baKiqMbXFPYE
         mIeUwU7cfA4SHtmrzn8EAA184FF85cJhLALJCJg719+6uIFxMXmd8GIY9qp6e23lVQ0/
         OD0A==
X-Gm-Message-State: AOJu0Yyfxx0pDTOoQPFxqZ1snVKKmd+yTpR9E/ErwIa4rQb9h3qlCa8s
        vCWqu7NEomGhWpaXVDplZZgzCQ==
X-Google-Smtp-Source: AGHT+IErWFOI+5mpTJPruxxPu/HCh/I/d5PjJGFFcz9x64Sr1ypRo/vmHHwuXiyLMwcEi6Zffq0s2g==
X-Received: by 2002:a05:6e02:1d18:b0:349:862e:a862 with SMTP id i24-20020a056e021d1800b00349862ea862mr20981355ila.20.1692118232575;
        Tue, 15 Aug 2023 09:50:32 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:f77a:c0d7:f137:55fe])
        by smtp.gmail.com with ESMTPSA id y19-20020a02a393000000b0042b0f3f9367sm3883054jak.129.2023.08.15.09.50.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 09:50:32 -0700 (PDT)
Date:   Tue, 15 Aug 2023 10:50:28 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 04/17] libtraceeval histogram: Have cmp and release
 functions be generic
Message-ID: <20230815165028.GA780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-5-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-5-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:27AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> Having the ability to override the compare function for a given type can
> be very advantageous. There's also no reason that any type could ask for a
> release callback to be called when the type is being released. It could be
> used for information as well as for freeing.
> 
> Rename traceeval_dyn_cmp_fn to traceeval_data_cmp_fn and
>  traceeval_dyn_release_fn to traceeval_data_release_fn and have
> them take the union traceeval_type instead of struct traceeval_dynamic.
> 
> Also this changes the compare to pass a pointer to union traceeval_data
> instead of passing in the structure of the dyn_data type.
> 
> In the structure, rename dyn_cmp to just cmp, and dyn_release to just
> release.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h | 46 +++++++++++++++++++++-------------------
>  src/histograms.c         | 28 ++++++++++++------------
>  2 files changed, 38 insertions(+), 36 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index f6c4e8efb2be..22e9029133d5 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
> @@ -65,13 +65,13 @@ union traceeval_data {
>  struct traceeval_type;
>  
>  /* struct traceeval_dynamic release function signature */

You may want to update the comment here to make it clear that this is now for
both dynamic and pointer types.  Ditto for the compare function signature.

> -typedef void (*traceeval_dyn_release_fn)(struct traceeval_type *,
> -					 struct traceeval_dynamic);
> +typedef void (*traceeval_data_release_fn)(struct traceeval_type *,
> +					  union traceeval_data *);
>  
>  /* struct traceeval_dynamic compare function signature */
> -typedef int (*traceeval_dyn_cmp_fn)(struct traceeval_dynamic,
> -				    struct traceeval_dynamic,
> -				    struct traceeval_type *);
> +typedef int (*traceeval_data_cmp_fn)(const union traceeval_data *,
> +				     const union traceeval_data *,
> +				     struct traceeval_type *);
>  
>  /*
>   * struct traceeval_type - Describes the type of a traceevent_data instance
<>
> @@ -588,7 +588,7 @@ static int copy_traceeval_data(struct traceeval_type *type,
>  /*
>   * Free @data with respect to @size and @type.
>   *
> - * Does not call dyn_release on type TRACEEVAL_TYPE_DYNAMIC.
> + * Does not call release on type TRACEEVAL_TYPE_DYNAMIC.

or for TRACEEVAL_TYPE_POINTER.

>   */
>  static void data_release(size_t size, union traceeval_data **data,
>  				struct traceeval_type *type)
> -- 
> 2.40.1

Aside from these two comment nits, you can add:

Reviewed-by: Ross Zwisler <zwisler@google.com>
