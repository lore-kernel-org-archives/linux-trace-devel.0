Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0051BC20
	for <linux-trace-devel@vger.kernel.org>; Sun, 25 Feb 2024 20:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708894087; cv=none; b=oVyfeQGWG7QgDCYS5yHTQSqgcmiTKMNnE4AgGfgavtN6PngIpYrIHGFCLfi3aR01hINijFLm9Mlr7r+WfxFRD589GsYtZBngDIXaCHt2sqhEsks8yEEaKA/5NVS3m0tNdnBrRBrinNHnW+rGJ84yrEJST7NwP8H1omD5FhKDmaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708894087; c=relaxed/simple;
	bh=MrjNZTqM5krAMLcYNGK4XzRByGR5HnzEc8qf664L1Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XBd+xFb0JD5SVT5YpBOZsKWPK3zcmMlsG1jrbG5YGuTlAO6KRIwTNA1QEUwj9FnE8SqDlAEZIWrV6UszCbwnPviDH7wA9CV5L/PppZ+lFJYP6CA71PQha2XV+lz14Z6mfU2AuSiuctqtlOG+cVy8rpqPeQD1hOYuAFXXKoOn0QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IzYxqi/N; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IzYxqi/N"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-33dcd8dec88so378075f8f.1
        for <linux-trace-devel@vger.kernel.org>; Sun, 25 Feb 2024 12:48:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1708894083; x=1709498883; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=MK7mm98qdgizs96h25moEhLggpGKB+32gkZ4wSYrwAA=;
        b=IzYxqi/N7p5uL1KPb155VWlAy+SDIwEwnjlgsmVQ/dsxSmM7Yn1k2kID8VGyz0tB3p
         cLiQ03eKI7SqHwnkwBZDlXBw/PqlF39SwNCtquOlAWf7++2O1vJ+gDxhguSZw7zl30hM
         zNw9OHuyWyj79Uav0uN/1iH23caa/dZBwgDj+qEf7bnFcNk4KGYiX2m3jPZs4pwFAtSa
         Hhs0t/WP3OlF4uzBjKUedOFkvIMmWg5uOEvMQlH+gNwscK9iYuVDjB1VZoaw4z33IOtj
         vxeuldArj/aRjF0Vynoa6a0F4FV4kjsstFa2qTIkuB0GCNN7Qrvtr54lGXzCgLN2bm4s
         E8gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708894083; x=1709498883;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MK7mm98qdgizs96h25moEhLggpGKB+32gkZ4wSYrwAA=;
        b=HBdF7i8pBANdnTzOzaZneeeM8mn3wAZSq7bcvc+EH794UwXq1fCr+843iJol6ZzmHv
         FUQhBt9ZxOYTFy1gs9op7DZjdTJW6OvwE0Koft09ntMEH0O67FkMmiXjlAQDJFtvMtKz
         DTVDktTuMPrYFW4kz5pdFQTvyIjZZP4nE5K5z8DKwR4Rd99Pjom1xFRSFhWt/l5yFK/9
         /82t3Oyhrn4E2b3nmUFtBwonTZzTUC88eVqHLZg68yGSOFA6jCPX6MJwMHnrAOUE1yJ8
         JMy4dqVYnf+md7BIy2+qfh1BFxxArxhUDRONAGuiYbmdvriTb19JgIAFFbP0UXWSsD92
         PKxA==
X-Gm-Message-State: AOJu0Ywu7FIHJId8egAf/zCPkJKMwzb4fUSSdwVdhlnL79ICVIwHd9W9
	RqIM1TUlu8aJOzHRaVcU2KKE4Av/FsqFAOLYi4mmbvABEBUpVa96/6PdDL2X
X-Google-Smtp-Source: AGHT+IFNeN0r0MCIieQoygxNHR1VSQ8E2FiJZTcb5z+l3FF2lnzKZ1CedrVO8Ph7hqvBvF/a7tGRlA==
X-Received: by 2002:a5d:6707:0:b0:33d:ca56:a61f with SMTP id o7-20020a5d6707000000b0033dca56a61fmr1525600wru.49.1708894082947;
        Sun, 25 Feb 2024 12:48:02 -0800 (PST)
Received: from kali.home (lfbn-ren-1-787-165.w83-197.abo.wanadoo.fr. [83.197.114.165])
        by smtp.gmail.com with ESMTPSA id q2-20020adfab02000000b0033cf5094fcesm6046343wrc.36.2024.02.25.12.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Feb 2024 12:48:02 -0800 (PST)
From: Fabrice Fontaine <fontaine.fabrice@gmail.com>
To: linux-trace-devel@vger.kernel.org
Cc: Fabrice Fontaine <fontaine.fabrice@gmail.com>
Subject: [PATCH] meson: add utest option
Date: Sun, 25 Feb 2024 21:47:58 +0100
Message-ID: <20240225204759.3263-1-fontaine.fabrice@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add utest option to allow the user to disable utest

Signed-off-by: Fabrice Fontaine <fontaine.fabrice@gmail.com>
---
 meson.build       | 2 +-
 meson_options.txt | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/meson.build b/meson.build
index 3156f1c..d4cfd53 100644
--- a/meson.build
+++ b/meson.build
@@ -35,7 +35,7 @@ incdir = include_directories(['include'])
 
 subdir('src')
 subdir('include')
-if cunit_dep.found()
+if get_option('utest') and cunit_dep.found()
     subdir('utest')
 endif
 if get_option('samples')
diff --git a/meson_options.txt b/meson_options.txt
index 8450992..a48efea 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -18,3 +18,5 @@ option('doc', type : 'boolean', value: true,
        description : 'produce documentation')
 option('samples', type : 'boolean', value: true,
        description : 'build samples')
+option('utest', type : 'boolean', value: true,
+       description : 'build utest')
-- 
2.43.0

