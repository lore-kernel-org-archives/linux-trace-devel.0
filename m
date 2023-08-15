Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0FA3C001B0
	for <linux-trace-devel@archiver.kernel.org>; Tue, 15 Aug 2023 19:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240005AbjHOTsn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 15 Aug 2023 15:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240004AbjHOTsP (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 15 Aug 2023 15:48:15 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADE11B2
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 12:48:14 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-1c11d53221cso3522564fac.2
        for <linux-trace-devel@vger.kernel.org>; Tue, 15 Aug 2023 12:48:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692128893; x=1692733693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=CJcMEY2/djKsCIBdv31QPV5NAQo5pL66OLNxGUUdf34=;
        b=5xNpBwCUrAS4ezT6UDGjOi8O/5DoIaSylkwFU41DEWfI3GkUau6m4nbluA/iJr7sWS
         cisw6YGKz9BvtHeVb0CHcIKgY0zp86MDDHKkvw1yloh31nlCGjZnFFNshL6tcP9lpTzM
         D2nh4ekGthg9uaiPrylfEWheAJB8yICGWb9v4wIl/L4K7kwR654nWI425k6OvRTA/joq
         jPfsdqea6w1Exb067NlDUSO4JwaWE2mHifOR4SDU3YDP6xe5yEDg7D3sRejCQum0NjQ1
         5fjnKzbAVHPGn9e0OpDE3UtNTIrAkJ03Q1Zm2wL/gaHouBkalaY1w8tPWEzJtZqlMkv1
         5H5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692128893; x=1692733693;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CJcMEY2/djKsCIBdv31QPV5NAQo5pL66OLNxGUUdf34=;
        b=Ge0wEpOIibISp5gJpBEdZ5+rmC6Kfvz3VHN6bzhdHo9hNCiUfR2CJlV04r2OdOp4xv
         R86UTHJ4te57DXptaZG0AaLkcbtTITSNae4Jqr1Lfb4yOgWCIcuSc/3e22Gitkz/A4x/
         fGQqXBAYCLDoOal2JqtZrr3JAn7df/BIq1MiWKeDDS7ZBOWFhYRmAv0ZjPa+lXG/Qkc+
         XLlbU17AT0xBqcTqyo8VculBwpKwVPwVZywByBDwbFmWnY1ylFsaL1PDMMppMFi634it
         X+iP8IYt97tkMp/cbS9DWEG8S91laGyBpCc+xi3LFrEa+iNatswik5OZC1RcWcJW/Pzm
         Teig==
X-Gm-Message-State: AOJu0YwfqrE0bdpx/wL9Hv+RRrO2Qk76jfsOY5Xzw6vDmQ/A3k/1sMUQ
        YsB6IvsqYuR9EBxUsyiC5PGaZk1NPm91LQLOTjex7Q==
X-Google-Smtp-Source: AGHT+IFuNeXHG6FczhrE7fFGBHvgKuDuj0ZxWTIkmE5cfK4iMziwpw2+o1pYzuEc4Vf63jUQza+lXQ==
X-Received: by 2002:a05:6870:31c5:b0:1be:c688:1c0 with SMTP id x5-20020a05687031c500b001bec68801c0mr14008758oac.47.1692128893332;
        Tue, 15 Aug 2023 12:48:13 -0700 (PDT)
Received: from google.com ([2620:15c:183:200:f77a:c0d7:f137:55fe])
        by smtp.gmail.com with ESMTPSA id u3-20020a02cbc3000000b0042b45475212sm3888780jaq.81.2023.08.15.12.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 12:48:12 -0700 (PDT)
Date:   Tue, 15 Aug 2023 13:48:09 -0600
From:   Ross Zwisler <zwisler@google.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org,
        Stevie Alvarez <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 09/17] libtraceeval histogram: Label and check keys
 and values
Message-ID: <20230815194809.GE780024@google.com>
References: <20230811053940.1408424-1-rostedt@goodmis.org>
 <20230811053940.1408424-10-rostedt@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230811053940.1408424-10-rostedt@goodmis.org>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Fri, Aug 11, 2023 at 01:39:32AM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> When initializing the traceeval descriptor, mark each key and value as
> their type via the flags (keys get TRACEEVAL_FL_KEY and values get
> TRACEEVAL_FL_VALUE) as well as adding the index of that key/value type of
> the key/value data it represents. This will be used by the iterators for
> sorting. The iterator will point to the key/value type and use that
> information to know which key/value data to sort with.
> 
> The keys and values passed in will also be updated to have their flags
> match the proper key/value type as well as the index. This will be useful
> for traceeval_stat() that will take the type as a parameter, and use it to
> figure out fast where the data is that is to be looked up.
> 
> All pointer and dynamic types in keys must have both a cmp and hash
> function defined, otherwise they cannot be indexed or hashed. Add a check
> to make sure all key types of pointer and dynamic have those functions.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> ---
>  include/traceeval-hist.h | 11 +++++---
>  src/histograms.c         | 60 ++++++++++++++++++++++++++++++++++++++--
>  2 files changed, 64 insertions(+), 7 deletions(-)
> 
> diff --git a/include/traceeval-hist.h b/include/traceeval-hist.h
> index 4baed4237787..1c02f3039809 100644
> --- a/include/traceeval-hist.h
> +++ b/include/traceeval-hist.h
<>
> @@ -248,6 +292,16 @@ struct traceeval *traceeval_init(const struct traceeval_type *keys,
>  		goto fail;
>  	}
>  
> +	ret = check_keys(keys);
> +	if (ret < 0)
> +		goto fail;
> +
> +	if (vals) {
> +		ret = check_vals(vals);
> +		if (ret < 0)
> +			goto fail;

These two goto statements should both be to fail_release so we clean up
'teval', else we could do this check above the alloc.

> +	}
> +
>  	/* alloc key types */
>  	teval->nr_key_types = type_alloc(keys, &teval->key_types);
>  	if (teval->nr_key_types <= 0) {
> -- 
> 2.40.1
> 
