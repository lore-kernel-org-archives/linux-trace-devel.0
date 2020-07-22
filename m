Return-Path: <SRS0=XgcI=BB=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D047C433E0
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 21:58:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E683F22B3F
	for <linux-trace-devel@archiver.kernel.org>; Wed, 22 Jul 2020 21:58:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726841AbgGVV6w (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 22 Jul 2020 17:58:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:52170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgGVV6w (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 22 Jul 2020 17:58:52 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E360C2086A;
        Wed, 22 Jul 2020 21:58:51 +0000 (UTC)
Date:   Wed, 22 Jul 2020 17:58:50 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Vitaly Chikunov <vt@altlinux.org>
Cc:     linux-trace-devel@vger.kernel.org,
        "Dmitry V . Levin" <ldv@altlinux.org>
Subject: Re: [PATCH 2/2] Makefile: Fix build of utest on systems with
 --as-needed enabled
Message-ID: <20200722175850.2ff17897@oasis.local.home>
In-Reply-To: <20200720164453.5161-2-vt@altlinux.org>
References: <20200720164453.5161-1-vt@altlinux.org>
        <20200720164453.5161-2-vt@altlinux.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Mon, 20 Jul 2020 19:44:53 +0300
Vitaly Chikunov <vt@altlinux.org> wrote:

> On systems (such as ALT Linux) where `--as-needed' is passed to ld by
> default, building tests fail due to CUNIT_INSTALLED test failure to link
> with libcunit, becasue `-lcunit' is passed before input file (which is
> `-'). Move `-lcunit' after '-' to link it properly.
> 
> To reproduce `make CC='gcc -Wl,--as-needed' test`. Error message:
> 
>   Makefile:344: *** CUnit framework not installed, cannot build unit tests.  Stop.
> 
> Signed-off-by: Vitaly Chikunov <vt@altlinux.org>
> Cc: Dmitry V. Levin <ldv@altlinux.org>

I applied both these patches and released 2.9.1.

Thanks Vitaly!

-- Steve

> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 6b606da..83e5646 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -242,7 +242,7 @@ ifeq ($(VSOCK_DEFINED), 1)
>  CFLAGS += -DVSOCK
>  endif
>  
> -CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c -lcunit - >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
> +CUNIT_INSTALLED := $(shell if (printf "$(pound)include <CUnit/Basic.h>\n void main(){CU_initialize_registry();}" | $(CC) -x c - -lcunit >/dev/null 2>&1) ; then echo 1; else echo 0 ; fi)
>  export CUNIT_INSTALLED
>  
>  export CFLAGS

