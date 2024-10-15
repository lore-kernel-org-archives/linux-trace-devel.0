Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FFE51DD0EA
	for <linux-trace-devel@vger.kernel.org>; Tue, 15 Oct 2024 15:44:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729007064; cv=none; b=R7ngKd0ZC7u7ExNguHv8EoSLSceSl6nsLZUI6ObV6wptg9sbGJSJHiloTDgRPPk/enT00JAMJXgwoWPM/9N+Q44K1fmK883gzBfNi4FdQ6Ltd5zZ2G82iATkW/i2OdGQGf+wZHGBL1lOdCxh1RvIOYd+M4iVJ6xXzMJRVG9YUxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729007064; c=relaxed/simple;
	bh=HPxL1NPON3+cWasRK0aULrLUU/HpKSZUwOReKphL6i4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=Tq3WIbpcZTPnFtQr2qJ3ulI+HKldoxxK0nTDxOGFhA6mh5ht1mgE9IOPVRjssu4QOt0WjiqV0nFh7C3Vxhg1V8jpfOzHnRecra885+vvWNRWzSI0TM88MSGb0R9sFIGRj6gADgg7WYBqQWz7PPBt5HPwf2bj+vCC7I6rx5h7Nb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57E271763;
	Tue, 15 Oct 2024 08:44:52 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 45E9D3F528;
	Tue, 15 Oct 2024 08:44:22 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH] trace-cmd .gitignore: Ignore utest/trace-utest in git
Date: Tue, 15 Oct 2024 16:44:13 +0100
Message-Id: <20241015154413.4189532-1-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index eb1b0dbe..a746b856 100644
--- a/.gitignore
+++ b/.gitignore
@@ -27,3 +27,4 @@ build_prefix
 build_install
 build_libs_install
 ltc_version.h
+utest/trace-utest
-- 
2.34.1

