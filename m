Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 756A719F429
	for <linux-trace-devel@vger.kernel.org>; Thu, 10 Oct 2024 08:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728550441; cv=none; b=SwlhwrzbtoEDO4fy68OmK8NODgai0ynN/1lEYcrLcnyHEgCOE50gtiOIqi3ut7XHAYOd4k/Ptg2mXtyBt2wvr5jKuBjTOtwHVLxaj71AllPUjr5QQaUEOdlEY6P2M6/R7EZGLauWZEKB69a6Fl4tAZjO3kodqScacIpf2iDqvcQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728550441; c=relaxed/simple;
	bh=cNnnwca+XHOlXyPpSpfcHA9Wote+GZZSA+BRJ+n+lXI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qVEfoQvoos1PFVjeWy+prDxHJicwF+wyxK8S9cG9bXyM7FrAwIkgFphwFe+2Ggc5ii1jOA7n0x5VgeJCc4PBEhI72Hvi+beFsqRdR0v5XWSVDkw72v2k6/UhYGJDgmveW+Lrw8Zwk2QELRzRlZrvyY4bOJ3RaD2nnD0naqcgyD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 73CB4DA7;
	Thu, 10 Oct 2024 01:54:28 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 5772C3F64C;
	Thu, 10 Oct 2024 01:53:58 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH 1/2] trace-cmd reset: Bail out immediately if user provides an invalid option
Date: Thu, 10 Oct 2024 09:53:49 +0100
Message-Id: <20241010085350.3479149-2-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241010085350.3479149-1-metin.kaya@arm.com>
References: <20241010085350.3479149-1-metin.kaya@arm.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

trace_reset() does not care invalid command line options and carries on
execution. For instance, "trace-cmd reset -x" command successfully
completes the reset request (despite of "reset: invalid option -- 'x'"
warning). Thus, show the usage message and terminate execution instead
of running the reset routine.

Signed-off-by: Metin Kaya <metin.kaya@arm.com>
---
 tracecmd/trace-record.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tracecmd/trace-record.c b/tracecmd/trace-record.c
index 3c705270..c695cd23 100644
--- a/tracecmd/trace-record.c
+++ b/tracecmd/trace-record.c
@@ -6102,6 +6102,9 @@ void trace_reset(int argc, char **argv)
 				instance->flags &= ~BUFFER_FL_KEEP;
 			}
 			break;
+		default:
+			usage(argv);
+			break;
 		}
 	}
 	update_first_instance(instance, topt);
-- 
2.34.1

