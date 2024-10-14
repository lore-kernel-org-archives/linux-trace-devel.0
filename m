Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AFF21A071E
	for <linux-trace-devel@vger.kernel.org>; Mon, 14 Oct 2024 12:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728909109; cv=none; b=DXN5ELuWMROAeXF5V/zTI6weyYp07BKPY1XKtqROEInf9a7UZC7FQuNqmr2hZwfyDRFFkynV1Ct9VxZrUqqCwpB3Yd9L0ADg24hxJ7TtqyjUkJY/a0MTHCIycDGqzTJ+ZHypvaPQZZ25lHx95ZNbcwvxywm1BctIi65YjDeMiho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728909109; c=relaxed/simple;
	bh=pRhJ+HxfKK6ioFjQDKdDo7dOuFeprGVHhGzPthqt+II=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AdaBHJrFYTF7k3xPuEDeOEKsAKNdIYkOIj2zwC5T6Retkl1MaEYpjGQkEd63sXD78n9f61YbzcQ1d3ZDRZXaDJ5QDfjKN4KB38rBBLFYMJWsxGOS+MiZahbE5p1a+KvDSozFKqzv8RbZl14CckGamhdqIDo12fmaQdHZSNpB1Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 64C5D1424;
	Mon, 14 Oct 2024 05:32:16 -0700 (PDT)
Received: from e133381.cambridge.arm.com (e133381.arm.com [10.1.198.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2F1373F71E;
	Mon, 14 Oct 2024 05:31:46 -0700 (PDT)
From: Metin Kaya <metin.kaya@arm.com>
To: linux-trace-devel@vger.kernel.org
Cc: metin.kaya@arm.com
Subject: [PATCH v2 1/4] trace-cmd reset: Bail out immediately if user provides an invalid option
Date: Mon, 14 Oct 2024 13:31:33 +0100
Message-Id: <20241014123136.3890807-2-metin.kaya@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20241014123136.3890807-1-metin.kaya@arm.com>
References: <20241014123136.3890807-1-metin.kaya@arm.com>
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
index 0063d528..8c0039d4 100644
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

