Return-Path: <SRS0=Y1eu=S3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BEE8C10F03
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 09:43:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 376082084F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 09:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H/d/pYAv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbfDYJn6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 05:43:58 -0400
Received: from mail-wr1-f53.google.com ([209.85.221.53]:36954 "EHLO
        mail-wr1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfDYJn6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 05:43:58 -0400
Received: by mail-wr1-f53.google.com with SMTP id t17so17645959wrr.4
        for <linux-trace-devel@vger.kernel.org>; Thu, 25 Apr 2019 02:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language;
        bh=FpudFmFS7PI/Qamdz2ZadRuv3CLVzW3dH29ufetIoNM=;
        b=H/d/pYAvetzXg+JVXwyUKcMNRvfHvj88Ig+Hrsx6X+ljHf3GGUoEbOZQ7pjN7p3Dli
         uVbE4FXacn6pTHzTpj4AEXc84DRxLXHaJd4Ms6vjiG3Na6IpRqL0amjASyHKQ6MzY+KD
         T8vxPVx4p1CAQeuQnh1WQv1hCm1eznMqrYNFqpcEq47w17DxMmUKBfG6LJ0GHHivaNDv
         KkvPbEnLbqNObaooogh76zXnqS00zfGxDx7JTzakjTBbbz6dXn5EHFPh8IOQnBegu3Ur
         2KA0Xc46sg8OCz8I7Za/4WUwzlR7k0SpHlEab5IijDdZipRgICbh2mXJRCJGWmLuSPv9
         YZZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=FpudFmFS7PI/Qamdz2ZadRuv3CLVzW3dH29ufetIoNM=;
        b=AxpDU+fOp17RVKFGCikIs0jRE6FmKHSPv/SwLflLn6bSh4nF4+BROQGWBRA9ghAKSR
         8CWtC+jlx3TRA71R3SXxpCT1nmSrCKzGXg2ayfC4575Lh+xO9xdisMI5Ez9cRb2fqFIl
         TphWerqQG3rNu8O2iJ33MRurmKeLdQP7gD+NP8Kb3Vq7k8+ZIDapr68IoyurUTVvZqeV
         hoU+5sfI6ptC7YM7TTsyWVIjUvWgey/4njlu6RufM1NDgBbTKtjPHQsX7Gm210MKuN5W
         ZFU4ONCN81SbPi9nYmpR/wIiogkvRaTOacYc2Ulez8LCy+tNh2DrAcOEZNJcxo2WHoP8
         1L2Q==
X-Gm-Message-State: APjAAAWb29yxCmK2xKshYBKp63ZVz5YALNAHbnrBJjNG74WEX9oOUMYT
        qrfJfLD/aL1O8KTOzlA/vgmabFZo
X-Google-Smtp-Source: APXvYqwoux2p+tDuCH9A5yHJw7q6iuS+zJ9i7TGKfZc43rKOOWcrgb64VLHlBp+R0ZWnCNHkn3fdSQ==
X-Received: by 2002:a05:6000:cc:: with SMTP id q12mr14232282wrx.251.1556185436814;
        Thu, 25 Apr 2019 02:43:56 -0700 (PDT)
Received: from [10.27.113.15] ([146.247.46.5])
        by smtp.gmail.com with ESMTPSA id o6sm43012043wre.60.2019.04.25.02.43.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 02:43:55 -0700 (PDT)
Subject: Re: KernelShark not rendering correctly
To:     Steven Rostedt <rostedt@goodmis.org>,
        Yordan Karadzhov <ykaradzhov@vmware.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
References: <20190423104158.292c665a@gandalf.local.home>
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Message-ID: <e079067a-2b6a-7847-9754-10e515fa8c1a@gmail.com>
Date:   Thu, 25 Apr 2019 12:43:54 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190423104158.292c665a@gandalf.local.home>
Content-Type: multipart/mixed;
 boundary="------------9873951DCA6771E028FEFB34"
Content-Language: en-US
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------9873951DCA6771E028FEFB34
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Steven,

I managed the reproduce a similar behavior by saving a session at one 
screen resolution then changing the resolution and reopening the 
session. Not sure if you did the same.
Attached is a patch that fixes the bug for me. Please test it and tell 
me if it also fixes the bug for you.

Thanks!
Yordan



On 23.04.19 г. 17:41 ч., Steven Rostedt wrote:
> Hi Yordan,
> 
> To test your zoom patch, I opened my old json file that I sent you, but
> noticed that it comes up without the right dimensions for the graph.
> 
> Here's a screenshot:
> 
>    http://rostedt.homelinux.com/private/ks-off.png
> 
> If I resize the window it will eventually go back to normal. But I
> figured I'd let you take a look. I'm guessing it has something to do
> with the saved json file was for a smaller window than the one that
> opened it.
> 
> -- Steve
> 

--------------9873951DCA6771E028FEFB34
Content-Type: text/x-patch;
 name="rendering_bug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="rendering_bug.patch"

diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
index 5f326f5..39bc7b5 100644
--- a/kernel-shark/src/KsMainWindow.cpp
+++ b/kernel-shark/src/KsMainWindow.cpp
@@ -433,7 +433,6 @@ QString KsMainWindow::lastSessionFile()
 void KsMainWindow::_restoreSession()
 {
 	loadSession(lastSessionFile());
-	_graph.updateGeom();
 }
 
 void KsMainWindow::_importSession()
@@ -448,7 +447,6 @@ void KsMainWindow::_importSession()
 		return;
 
 	loadSession(fileName);
-	_graph.updateGeom();
 }
 
 void KsMainWindow::_updateSession()
@@ -1098,6 +1096,7 @@ void KsMainWindow::loadSession(const QString &fileName)
 
 	_session.loadTable(&_view);
 	_colorPhaseSlider.setValue(_session.getColorScheme() * 100);
+	_graph.updateGeom();
 }
 
 void KsMainWindow::_initCapture()
diff --git a/kernel-shark/src/KsTraceGraph.cpp b/kernel-shark/src/KsTraceGraph.cpp
index 6087e96..598ef70 100644
--- a/kernel-shark/src/KsTraceGraph.cpp
+++ b/kernel-shark/src/KsTraceGraph.cpp
@@ -538,6 +538,8 @@ void KsTraceGraph::updateGeom()
 			       * allow the scroll bar to disappear when the
 			       * widget is extended to maximum.
 			       */
+
+	_glWindow.resizeGL(_glWindow.width(), _glWindow.height());
 }
 
 void KsTraceGraph::_updateGraphLegends()

--------------9873951DCA6771E028FEFB34--
