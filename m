Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F0AC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sat, 15 Jan 2022 17:01:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiAORBn (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 15 Jan 2022 12:01:43 -0500
Received: from smtpx.feld.cvut.cz ([147.32.210.153]:48713 "EHLO
        smtpx.fel.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiAORBn (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 15 Jan 2022 12:01:43 -0500
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Jan 2022 12:01:42 EST
Received: from localhost (styx [192.168.200.7])
        by smtpx.fel.cvut.cz (Postfix) with ESMTP id BEB721F358;
        Sat, 15 Jan 2022 17:54:20 +0100 (CET)
X-Virus-Scanned: IMAP STYX AMAVIS
Received: from smtpx.fel.cvut.cz ([192.168.200.2])
        by localhost (styx.feld.cvut.cz [192.168.200.7]) (amavisd-new, port 10060)
        with ESMTP id xNy1PTKI7_5O; Sat, 15 Jan 2022 17:54:19 +0100 (CET)
Received: from steelpick.2x.cz (ip-94-112-192-124.net.upcbroadband.cz [94.112.192.124])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sojkam1)
        by smtpx.fel.cvut.cz (Postfix) with ESMTPSA id E043D1F4D6;
        Sat, 15 Jan 2022 17:54:18 +0100 (CET)
Received: (nullmailer pid 445690 invoked by uid 1000);
        Sat, 15 Jan 2022 16:54:17 -0000
From:   Michal Sojka <michal.sojka@cvut.cz>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>,
        y.karadz@gmail.com
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2] kernel-shark: Use cmake imported targets instead of
 variables
In-Reply-To: <20220113124322.292222-1-tz.stoyanov@gmail.com>
References: <20220113124322.292222-1-tz.stoyanov@gmail.com>
Date:   Sat, 15 Jan 2022 17:54:16 +0100
Message-ID: <87fspp0wjr.fsf@steelpick.2x.cz>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Tzvetomir and Yordan,

I'm not sure my sign-off is necessary, but if Yordan wants it, you have
it :-)

Cheers,
-Michal

On Thu, Jan 13 2022, Tzvetomir Stoyanov (VMware) wrote:
> Using cmake imported targets instead of package variables is
> recommended way to define package dependencies.
>
> The GLUT_LIBRARY cmake variable was renamed in cmake 3.22.1, which
> breaks the Kernel Shark build with the latest cmake.
>
> Reported-by: Michal Sojka <michal.sojka@cvut.cz>
> Signed-off-by: Tzvetomir Stoyanov (VMware) <tz.stoyanov@gmail.com>

Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>

> ---
>  src/CMakeLists.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
> index babb9c1..9e0b4ae 100644
> --- a/src/CMakeLists.txt
> +++ b/src/CMakeLists.txt
> @@ -59,8 +59,8 @@ if (OPENGL_FOUND)
>                                       KsPlugins.cpp)
>  
>      target_link_libraries(kshark-plot  kshark
> -                                       ${GLUT_LIBRARY}
> -                                       ${OPENGL_LIBRARIES})
> +                                       GLUT::GLUT
> +                                       OpenGL::GLU)
>  
>      set_target_properties(kshark-plot PROPERTIES  SUFFIX ".so.${KS_VERSION_STRING}")
>      install(TARGETS kshark-plot
> -- 
> 2.34.1
