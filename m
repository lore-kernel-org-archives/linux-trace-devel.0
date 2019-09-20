Return-Path: <SRS0=kuh0=XP=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B635C49ED7
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 12:00:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6B1C1208C3
	for <linux-trace-devel@archiver.kernel.org>; Fri, 20 Sep 2019 12:00:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hGYaqMt8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408842AbfITMAT (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 20 Sep 2019 08:00:19 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:50294 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405262AbfITMAT (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 20 Sep 2019 08:00:19 -0400
Received: by mail-wm1-f65.google.com with SMTP id 5so2182005wmg.0
        for <linux-trace-devel@vger.kernel.org>; Fri, 20 Sep 2019 05:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9y72noXbx8on9kUXbSBZvp/F70sKA57m22vAgGHA50M=;
        b=hGYaqMt8vUHEkfHUQm4duqO8fnxgTmFI7GfTBlKCzBRDTbdjAKFomzVTdX/qMyM0ru
         XcFy2d1+xiRnMRKf1j852ZU2VEfbqVWrpgFFi57WewVwbXjkXPr8ecFCQU5XZWq1OGel
         y5jIhMmzsjCLCpDWt+GByl8ZYoxr3tK1LalP5a1r/5+jUCz8QCXb2/xA9Ea1VZWCenm9
         ixvJiA+C+Xjln2KH+XuTNXj3o0He9ybHhBkVhoQ5wMtvsPf3YkT2v+f1RcM6ikAR3rfm
         xj6tWtTAGcOF6cttgbPXMVE9DvoV1Ue38d0KZso5CXd7srsm45WL2pQmGmMeMDSOZiJK
         o2Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9y72noXbx8on9kUXbSBZvp/F70sKA57m22vAgGHA50M=;
        b=hgMNBaHoi9tuEQpCGsMKkrJg08bWbW7xqtaDp+v3rVRD13mdJgGBhC1J2cOskWT/WP
         scTJ9Mbbq2SiUMQieRWt+NEsiIQt/E8gCaDuJkt5bPhvkUvLC4WGBM3DjN4PZTcicg5+
         ILGJpjgdSrblHK06gY0CrcDxNFH2lMmH+2RwsZa8jvzLQ+DTRvyQctzQ02hammxY2Xv1
         aIXPoZmM8AovTUTpm7kUL2BGN1dYC2Z8fhVIwKo/6GwgZFwUPDTnqDtWNDSAG18/uuR3
         f8t/fM7kmatA3fzBEDII9ItitcHIzEUqYUMaU/iLYXQDx7BskA7Kho9e6e8ofg8wuulN
         4N2w==
X-Gm-Message-State: APjAAAXSrfUxaPKimKXK85s03nBSnataT0ivdm9t+piTD550hS9+9iEZ
        0qMRbqJXfzexqqxTEw3R2WMKgC5u
X-Google-Smtp-Source: APXvYqyQUz2hKu5P3uuYWZNJY//DC3pGok5zP/mp18KYqY9JJ6Wpp8fB1veMngWkVZ1AWc2s4uQAnQ==
X-Received: by 2002:a05:600c:118a:: with SMTP id i10mr3190822wmf.80.1568980816559;
        Fri, 20 Sep 2019 05:00:16 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id n12sm1544017wmk.41.2019.09.20.05.00.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 20 Sep 2019 05:00:15 -0700 (PDT)
Subject: Re: [PATCH 2/4] trace-cmd: Correct the install paths of traceevent
 and trace-cmd libraries
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
References: <20190920104831.23475-1-y.karadz@gmail.com>
 <20190920104831.23475-3-y.karadz@gmail.com>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <9fc6f4ba-3095-1022-c13a-8a5df5ec3f0a@gmail.com>
Date:   Fri, 20 Sep 2019 15:00:26 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190920104831.23475-3-y.karadz@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This one is wrong. Please ignore it.
I am sending v2.

Thanks!
Yordan

On 20.09.19 г. 13:48 ч., Yordan Karadzhov (VMware) wrote:
> In order to be able to use the installed versions of the library's headers
> (and the libraries itself) the directories structure of the source has to
> be reprodused in the install location.
> 
> This modification is needed by the NumPy interface of KernelShark.
> 
> Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> ---
>   Makefile | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index dabdf8d..7124b2f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -344,12 +344,12 @@ install_gui: install_cmd gui
>   	$(Q)$(MAKE) $(S) -C $(kshark-dir)/build install
>   
>   install_libs: libs
> -	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ))
> -	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ))
> +	$(Q)$(call do_install,$(LIBTRACECMD_SHARED),$(libdir_SQ)/trace-cmd)
> +	$(Q)$(call do_install,$(LIBTRACEEVENT_SHARED),$(libdir_SQ)/traceevent)
>   	$(Q)$(call do_install,$(src)/include/traceevent/event-parse.h,$(includedir_SQ)/traceevent)
>   	$(Q)$(call do_install,$(src)/include/traceevent/trace-seq.h,$(includedir_SQ)/traceevent)
> -	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ))
> -	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(includedir_SQ))
> +	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-cmd.h,$(includedir_SQ)/trace-cmd)
> +	$(Q)$(call do_install,$(src)/include/trace-cmd/trace-filter-hash.h,$(includedir_SQ)/trace-cmd)
>   
>   doc:
>   	$(MAKE) -C $(src)/Documentation all
> 
