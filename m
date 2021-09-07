Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C080C433EF
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Sep 2021 20:31:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1904161103
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Sep 2021 20:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346492AbhIGUcv (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Sep 2021 16:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243733AbhIGUcu (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Sep 2021 16:32:50 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01157C061575
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Sep 2021 13:31:44 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id p21-20020ac846150000b02902982d999bfbso540712qtn.7
        for <linux-trace-devel@vger.kernel.org>; Tue, 07 Sep 2021 13:31:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=fVIVeh23hRb100FlM9U/lR433fpETpihutC18GrYSDc=;
        b=m3HX+HczQDeP0y1mLUiAFdulz+aR0bVxdiEqbY9H/E6B/FvxAzDUiFyZB2YadZBCcO
         RR/hvZC2C4b7oxamcBZwy3sgqp5ioVpWCOCPNd2KelhlQFa5icQ/TdLJk9KJYFFkCY02
         pTQnslaI6Tsyo4vxwiKDMSSEnzruGoDoTLM04rcDZ8XxCeC4QcO9v2DzWnYbrdkvC1Jw
         AhGEbuZ1yk14QOzQoSEcyd6c/feND5Hy6yg19LEtFCVHQjbFgI1Se3vckZwxsNyLtzke
         BLHoWQOK5BW9nJ9pXrz8Sj+PAe1wlCaXm7V8Ipw5RseER5a7npxEIzthELrd5lsMRLYu
         mozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=fVIVeh23hRb100FlM9U/lR433fpETpihutC18GrYSDc=;
        b=D32orONlA/G+nJmu1x6DZG1cvfhzCzEZwKBafVu6H9dywG5MCLAdrqWWBMANCRcSRj
         4+LULSBx9r/dFpfRsaCgKEvIeQ4w14SMa7niAYUonTO6vDg9xL2PED7bBdOQSOuM3F9z
         HuEVet6JfiDYFFQp5Yc16QrFz5MTbsxZgMeLc7x5fJIjIjnld7ZzjWMyA3dOxL3rHkeg
         CWpKnyAzxOITXNffR5JTjOHTs7HE6cC1hZCPCMGD6MrrL22vkFG6VV+Wl7nHcajevFEb
         VgCvPKy0BjSBMYouvTpEkiT/u3MoJ6aDmlhMpXP9tRpJPi4JAeyniyq55NahhB6f2ayY
         I3tQ==
X-Gm-Message-State: AOAM530Zy4EPl/EOHCcxxDGV+LcVpzT4nI9ADQhdIJomccqLGKWhnFrn
        evB7JsfgD/kXOXutF2hnQFIB5apK7mUynkiCRD4avzM+n1jacyX65ubr1iwe3LQHTL4gH6azbPc
        0iEpxREXK2wbDjp34I0FQnRdmvhonWcn6nN9hpr9wp2BALVHoNkeYsfs5nwZddrjOf/8yA+t1bJ
        1hOFo=
X-Google-Smtp-Source: ABdhPJxSCZrN10x8DKvvCaGn9H3nKtvBkXGn9Ocww5PCmUdQshTyzg+x5s7KtuldbygBoi+DWNhqS92ODh5u
X-Received: from irogers.svl.corp.google.com ([2620:15c:2cd:202:53e9:5aba:8d75:960d])
 (user=irogers job=sendgmr) by 2002:a05:6214:1843:: with SMTP id
 d3mr143226qvy.10.1631046702361; Tue, 07 Sep 2021 13:31:42 -0700 (PDT)
Date:   Tue,  7 Sep 2021 13:31:37 -0700
Message-Id: <20210907203137.3954523-1-irogers@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v2] libtracefs: Fix sometimes uninitialized warning.
From:   Ian Rogers <irogers@google.com>
To:     linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Ian Rogers <irogers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The warning with clang looks like:

src/tracefs-sqlhist.c:1107:2: error: variable 'cmp' is used uninitialized whenever switch default is taken [-Werror,-Wsometimes-uninitialized]
        default:
        ^~~~~~~
third_party/libtracefs/src/tracefs-sqlhist.c:1112:35: note: uninitialized use occurs here
                            filter->lval->field.field, cmp, val);
                                                       ^~~
third_party/libtracefs/src/tracefs-sqlhist.c:1033:2: note: variable 'cmp' is declared here
        enum tracefs_compare cmp;

Signed-off-by: Ian Rogers <irogers@google.com>
---
 src/tracefs-sqlhist.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/src/tracefs-sqlhist.c b/src/tracefs-sqlhist.c
index 88e9675..d77ce86 100644
--- a/src/tracefs-sqlhist.c
+++ b/src/tracefs-sqlhist.c
@@ -1097,7 +1097,8 @@ static int build_filter(struct tep_handle *tep, struct sqlhist_bison *sb,
 	case FILTER_BIN_AND:	cmp = TRACEFS_COMPARE_AND; break;
 	case FILTER_STR_CMP:	cmp = TRACEFS_COMPARE_RE; break;
 	default:
-		break;
+		fprintf(stderr, "Error invalid filter type '%d'", filter->type);
+		return ERANGE;
 	}
 
 	ret = append_filter(synth, TRACEFS_FILTER_COMPARE,
-- 
2.33.0.153.gba50c8fa24-goog

