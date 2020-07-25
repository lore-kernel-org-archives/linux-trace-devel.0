Return-Path: <SRS0=cf6o=BE=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8915C433EB
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jul 2020 07:06:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9451206F6
	for <linux-trace-devel@archiver.kernel.org>; Sat, 25 Jul 2020 07:06:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LPoG0JMa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbgGYHGZ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 25 Jul 2020 03:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgGYHGY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 25 Jul 2020 03:06:24 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AB4C0619D3
        for <linux-trace-devel@vger.kernel.org>; Sat, 25 Jul 2020 00:06:24 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f7so10146939wrw.1
        for <linux-trace-devel@vger.kernel.org>; Sat, 25 Jul 2020 00:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CXFHLe1YQF93BZ/rs6GMNyr5Yz9TM2DmnexAGv75gy0=;
        b=LPoG0JMaZGFm3dwHjIO0h/2vDOvyTeegPBXlLUvsbDi0Sx8th2fesLFU9jbGCL6/8a
         pVtuz5I+f5YZcTuot0D2AIK3Z3PF+KittIB1Fx4EJINcLSelzmx9ivqmbHC0a4Y84N2Q
         yzGIxSMMJlRayquzncjgsew1w380Ejjqz70Q4DjPO2uPqp30U5oMBOK/aaovB8zPHE19
         b26eDKSKRKqt5EOYywmClsZ4CKHgQKjuw5gNF9fasrZrs7ALnTRskunMD2ZE//TZQKcf
         2wB7uPCPTVnH/Whp4S9M97RvzZduysy8vXI4SNWXybDsMH7vF1GujGChdhoKgaQuSeFu
         6GcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=CXFHLe1YQF93BZ/rs6GMNyr5Yz9TM2DmnexAGv75gy0=;
        b=R7bdWmoDoV55nad7ulL3DMH00D+f09pYMgHPvUQgjx20kMteEWDUQwHtxUDMtaCP5M
         UDEs8XEXiPuxVQ28nYgwv688Z7hGnlOe1gHF4Q+hIBbhsOHVVYx5x/tDZNoAq4RPZHlF
         mgbPwKK2Vva517k63CXxKtQtJtNtvpg2uNrLXaTaqEWyfcHb8f3Hs+zkxPEzrf/AL2h9
         C5rXJ1ldxLSvuOQD7OJXguiShLxLJlIOFnDrwJWagNTul/27VNQf29LZeF/Z0ncGjd4m
         qGLLcskbkS6VvD5S1b6ky5xINcN+66oV7MvS/MokVMEq4GTZdBQLgOfWHLAl740msNv/
         6Neg==
X-Gm-Message-State: AOAM532Gleii7J3iuemxtI3w6BxIH+DsR1KmTZKs5Zt1seagWYFZgT90
        gJmxzH7FU3YfSk4H3OWsYoCuYeZS+9k=
X-Google-Smtp-Source: ABdhPJwpqPXkTXlh5OgZDiXZwZHipPyfUroyi0dFsiw+olhKEyKTyPVwkFX8wyEn1kxK3echuMjYLg==
X-Received: by 2002:adf:b198:: with SMTP id q24mr11098635wra.335.1595660782947;
        Sat, 25 Jul 2020 00:06:22 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id u186sm9900047wmu.10.2020.07.25.00.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 00:06:21 -0700 (PDT)
Date:   Sat, 25 Jul 2020 09:06:20 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Arnaldo Carvalho de Melo <acme@kernel.org>,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Fix build with binutils 2.35
Message-ID: <20200725070620.GA4017955@eldamar.local>
References: <20200725010623.GA194964@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725010623.GA194964@decadent.org.uk>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On Sat, Jul 25, 2020 at 02:06:23AM +0100, Ben Hutchings wrote:
> In binutils 2.35, 'nm -D' changed to show symbol versions along with
> symbol names, with the usual @@ separator.  When generating
> libtraceevent-dynamic-list we need just the names, so strip off the
> version suffix if present.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: stable@vger.kernel.org
> ---
>  tools/lib/traceevent/plugins/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/plugins/Makefile b/tools/lib/traceevent/plugins/Makefile
> index 349bb81482ab..680d883efe05 100644
> --- a/tools/lib/traceevent/plugins/Makefile
> +++ b/tools/lib/traceevent/plugins/Makefile
> @@ -197,7 +197,7 @@ define do_generate_dynamic_list_file
>  	xargs echo "U w W" | tr 'w ' 'W\n' | sort -u | xargs echo`;\
>  	if [ "$$symbol_type" = "U W" ];then				\
>  		(echo '{';                                              \
> -		$(NM) -u -D $1 | awk 'NF>1 {print "\t"$$2";"}' | sort -u;\
> +		$(NM) -u -D $1 | awk 'NF>1 {sub("@.*", "", $$2); print "\t"$$2";"}' | sort -u;\
>  		echo '};';                                              \
>  		) > $2;                                                 \
>  	else                                                            \

FWIW, tested on a system with binutils 2.35 for a 5.7.10 build.

Tested-by: Salvatore Bonaccorso <carnil@debian.org>

Regards,
Salvatore



-- 
  .-.  Salvatore Bonaccorso --------------- Debian GNU/Linux Developer
  oo|  ----------------------------------------- http://www.debian.org
 /`'\  GPG key ID: 0x789D6F057FD863FE --------------------------------
(\_;/) Fingerprint: 04A4 407C B914 2C23 030C  17AE 789D 6F05 7FD8 63FE
