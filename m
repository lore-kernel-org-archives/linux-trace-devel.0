Return-Path: <SRS0=lsLa=5Z=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46B8DC2BA2B
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08DE9208FE
	for <linux-trace-devel@archiver.kernel.org>; Thu,  9 Apr 2020 13:28:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cTnJacqM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbgDIN2C (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 9 Apr 2020 09:28:02 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:34040 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726632AbgDIN2B (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 9 Apr 2020 09:28:01 -0400
Received: by mail-lf1-f43.google.com with SMTP id x23so7900328lfq.1
        for <linux-trace-devel@vger.kernel.org>; Thu, 09 Apr 2020 06:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+iDGuPZB8ElDv6syznIuOvWtfbCUX/l6SWZghpd5bJo=;
        b=cTnJacqMvYA60Oa/M3EjkMIhxE2VIkWL+cCwqsf73RNr24Yb+dFOvV/qnzIWzaC0Dq
         uQ3OeqN2uyQgbKwuypeeDhiMR2wrIa9cfftEp2iWwM3k3O9s+9DS6/bcnQMUjT0qhbpH
         TzxCdpXbbBTv7uFQhqLcZYS2ZfOt3iVWj++Ssnw++74usGbDLI6TEaSLucg4qmNJQAK/
         d5IuQ3DO839pnFPwuhMKXW241XSTKN1CtUQdxf5b2AX/zRJfq2RqXpFnKGy2k7lWBCz4
         xHZHzeLF0Fko2vDT81JHuo7W3WEEgwf+cveL7Yplp+A/cW9q37ycqyPiIrYV4wPGCn7h
         qkvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+iDGuPZB8ElDv6syznIuOvWtfbCUX/l6SWZghpd5bJo=;
        b=YASQdRuD3TJWwfDDU/XXcZu9pjgCrpHrMc0zJoaaloLCFZcmuJ2BXmhFAd5CKHbA3G
         nBz5dbMNAcWO2+hdpBlaVQ3lloNrTlEkGWes5LI+5yxZyiirrfCgc684YD1ILPOhWnrX
         j4hs9aaFhn7MyrD+PB6NsRCUrL2lbDhQeoYc2oRm3fwdQwtGgphV0/6E/WGMhmajffv3
         xzoFDrSYB+LbtyrNSIlYWwrMlNpUgT8j6ATBKUuuzLtoWYHfQiPc8Qkgi/mCUU0Xxudd
         1Ruhnaf9bdLgZVJw49DXtFhqmXeyGqB9h7fHyYdiu3/50PIl1RJI/fup0MeTtZuDJnz6
         fPtQ==
X-Gm-Message-State: AGi0Pua6stInX1INIYRrGcyklQuq8ujMpS9Anm3FwDOP3VzgACXzt0bs
        dusMarmJitGTruKgMm7xNJ9zTdSu3l8=
X-Google-Smtp-Source: APiQypKzR/ou5VBEIVpDIwm9n+nxN5VkOq+VBI+VvebOw/99kCEeU+bMZTH9s7KO4NsmIs1KURCxVA==
X-Received: by 2002:ac2:46e5:: with SMTP id q5mr7015314lfo.11.1586438880161;
        Thu, 09 Apr 2020 06:28:00 -0700 (PDT)
Received: from oberon.zico.biz ([83.222.187.186])
        by smtp.gmail.com with ESMTPSA id f2sm1067220lfl.18.2020.04.09.06.27.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Apr 2020 06:27:59 -0700 (PDT)
From:   "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org
Subject: [PATCH 0/2] Small trace-cmd fixes
Date:   Thu,  9 Apr 2020 16:27:54 +0300
Message-Id: <20200409132756.79402-1-tz.stoyanov@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Small fixes, good to have in the next trace-cmd release.

Tzvetomir Stoyanov (VMware) (2):
  trace-cmd: Fix possible usage of not null-terminated string
  trace-cmd: Fix reading of the traceid option from trace.dat file

 lib/trace-cmd/trace-input.c  | 4 +++-
 lib/trace-cmd/trace-plugin.c | 1 +
 lib/trace-cmd/trace-util.c   | 1 +
 3 files changed, 5 insertions(+), 1 deletion(-)

-- 
2.25.1

