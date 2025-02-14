Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C2932153FA
	for <linux-trace-devel@vger.kernel.org>; Fri, 14 Feb 2025 12:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739536568; cv=none; b=cBl6xFdgMZxGT+Gdo0iKMYrWPas5nKnBtWThQED5cYX/gs9/gGRXzcr9jUq9zJsblKyMQ3ORCyYLWB8geteum/rI+5a4l9y/6JusErM0ASd/O9QRrCyTtGHqmcOOel7cfSMZgeSCh6u+NnDhrSZgBBP4WiU2zX4sZjayCUzbxTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739536568; c=relaxed/simple;
	bh=ArOqPz4AR/2UtgU6ZzY4CVVROiBfrjQnm7ncXgfmqas=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mpVqQymTn0OKosfjX90/t4L06KgThoJx9GBS7vCQUyJNUR2s33klYh8O5fV9GsJivMDwZQjxJ3kD725SMN/VMKZ/fsqX1638pA7CO9QZ2RVVvBrxmerjHrJv2PDviG8E5ENiAupGg6HaUwFYM8KdlhNhPpRVdCy807eESX7tmtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nWsR3OXa; arc=none smtp.client-ip=117.135.210.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nWsR3OXa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=fr9U8
	6RPV3rVwEGXid+PwZF3uW93bKVqTNcbQjT6A/Q=; b=nWsR3OXa/V/0pUKEDbcJ8
	Mq4fGzGRR2M4pekX7gudQsXhFhySeolG+bf4wpW4V6L/an67hDziJzaw8Cggp2dT
	12mlnM3/5k4QUQ5EdnQhKSKIlQJyQxJ0KRK7cRLLyN7z0FpU6r2GGe/v2LHa/OSu
	0+4zm1zXjd+kem3S0y+OMY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wBnj2KvOK9nbwJ3MA--.45981S2;
	Fri, 14 Feb 2025 20:36:00 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: linux-trace-devel@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH v1] libtracefs: Fix the read file failure code checking
Date: Fri, 14 Feb 2025 20:35:17 +0800
Message-ID: <20250214123531.13883-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnj2KvOK9nbwJ3MA--.45981S2
X-Coremail-Antispam: 1Uf129KBjvdXoW7JF1xXr4UGr15Cw17JF1DZFb_yoW3XFg_ua
	4kJF1kK3s5JanFkw13Zw1jvr1fX3sYqFs5GFs7XFZFkF4UAa4rXF9xurZ8GFy8Gr9FvFyf
	Ca1xJ3y0ywnxCjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRi2Nt3UUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiSg-ya2et7k-5-gABsx

The failure error code '-1' will be treated as 'true'. Only nonzero
number has buffer data returned successfully.

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 src/tracefs-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/tracefs-record.c b/src/tracefs-record.c
index a2dcfc2..6abc3aa 100644
--- a/src/tracefs-record.c
+++ b/src/tracefs-record.c
@@ -550,7 +550,7 @@ static int init_splice(struct tracefs_cpu *tcpu)
 	if (ret < 0)
 		return ret;
 
-	if (tfs_str_read_file("/proc/sys/fs/pipe-max-size", &buf, false)) {
+	if (tfs_str_read_file("/proc/sys/fs/pipe-max-size", &buf, false) > 0) {
 		int size = atoi(buf);
 		fcntl(tcpu->splice_pipe[0], F_SETPIPE_SZ, &size);
 		free(buf);
-- 
2.48.1

