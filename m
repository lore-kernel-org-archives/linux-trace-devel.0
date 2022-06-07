Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87808C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jun 2022 04:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbiFGE7c (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 00:59:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236654AbiFGE7b (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 00:59:31 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67E6C6A011
        for <linux-trace-devel@vger.kernel.org>; Mon,  6 Jun 2022 21:59:27 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id j6so14460934pfe.13
        for <linux-trace-devel@vger.kernel.org>; Mon, 06 Jun 2022 21:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=XWsJQSmZQr9nTEjqjWIiShQ5afm9OJTwboDVo8J2pVY=;
        b=b7KQXDKWK5rTfNsVPi81Cx2GabG2I0iEo89bMhQbhI5jzjpowG+c7uV3eaX/KKrKeq
         3ZzvsL3NEamzMLR8+0QJOAo5bodw5Txy2UFh0zXl0R4jk6bi54L1SylrtoXkT2d3Nadd
         DD20kVcZv9cUXTpCvytz7T0Brda7I9fpQ7dDeVf5U6sxr7wo+AX2N6E+//xysQN8FIYA
         rTETbXNYs3mut9MXEWExPsZ9N9vAzhyQ9keu/VjBWqsdcwc9cQ+P7VDxjJJKqVf9maAv
         QGgXCZX3Fk1zWrKC0kpGmiOva14SjYapzGiTsyjwMq+aKkcmcVoYH3J4Vd0s34/wktyc
         sp8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=XWsJQSmZQr9nTEjqjWIiShQ5afm9OJTwboDVo8J2pVY=;
        b=yMPptDRe5qGepn3W6VlBTxMrCM4L7x1gfssXANmoO28wnCx8Prhsh/IPEyelYzI2KX
         5DyfkOR4WwdMxWjxYu3GvxlvCWeIUyr/oATm/Gr/hNvxlpIZ4kkGOy8KVutJ/N7mTraf
         8orb+nwMHfszcAo8ucXGZ/anvcwvbAVdb9O9ld/X5rF7rjsXinjAo5M+mf5l+mDEi2wB
         GplzE2gEqoOoNI+6YSDjzymayWqybUdlio5vQYWueWa59J5/c6SZUuDbSVi1FbcOaC0T
         mjuQ6yEkkAvVELcAroG63pgxuLix/9Heh9xMjN+ODya48HIWD/yDFC3q/dv8Wh1IJnu9
         2JSg==
X-Gm-Message-State: AOAM531cvSesjJr/MeLSGpgBYlPfK1TxOjOoAh1aOdNyPG2lrw2nq4Lo
        lyvXyQ/L+DhhCISW5NMRn4vPVvfkqjiTHw==
X-Google-Smtp-Source: ABdhPJwSNlOeDuxvs4yWf/JRHimJgU421B60ohe0X6Cn0Hd/+F7Fhdn9FP/m8dstmZ7N+A+FVOL7gw==
X-Received: by 2002:aa7:88cb:0:b0:51c:2627:2c03 with SMTP id k11-20020aa788cb000000b0051c26272c03mr6909373pff.63.1654577966634;
        Mon, 06 Jun 2022 21:59:26 -0700 (PDT)
Received: from balhae.hsd1.ca.comcast.net ([2601:647:6780:cb0:a418:d98a:6e1f:22a])
        by smtp.gmail.com with ESMTPSA id u5-20020a170903108500b00161f9e72233sm11210664pld.261.2022.06.06.21.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 21:59:26 -0700 (PDT)
Sender: Namhyung Kim <namhyung@gmail.com>
From:   Namhyung Kim <namhyung@kernel.org>
To:     linux-trace-devel@vger.kernel.org
Cc:     Ian Rogers <irogers@google.com>
Subject: [PATCH] libtraceevent: Reset field properly in event_read_fields()
Date:   Mon,  6 Jun 2022 21:59:25 -0700
Message-Id: <20220607045925.814164-1-namhyung@kernel.org>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The field pointer is allocated and added to the fields list in a
loop.  But it might refer the previous one if it fails to parse before
allocating a new one.

In that case, it would free the previous field but didn't update the
link of the list for the one before it.  Moreover, it doesn't need to
free the previous one as it finished ok.  Let's reset the field
pointer at the end of each iteration so that it cannot see the
previous one.

This was found by a fuzz test with an event having only one field.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 src/event-parse.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 8f4fb59..1ba2a78 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -1902,6 +1902,7 @@ static int event_read_fields(struct tep_event *event, struct tep_format_field **
 
 		*fields = field;
 		fields = &field->next;
+		field = NULL;
 
 	} while (1);
 
-- 
2.36.1.255.ge46751e96f-goog

