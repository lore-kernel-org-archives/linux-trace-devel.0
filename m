Received: from smtp-relay-canonical-1.canonical.com (smtp-relay-canonical-1.canonical.com [185.125.188.121])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8233EA9A
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Dec 2024 05:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.121
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733464507; cv=none; b=mHZE4qa186BCVNyig7guRX2F23RFB1bmYhiJOxXqRxLh1g/IaseL5vS4dyu5AuA91R3OT1sjZ0VxZhvUhYYJZ+X/neuy42jJ+2ma3ducX/VtImzZLaK0tTz325lStphU+V1WnExsccKRNQJfmUwclHgZt8JYN7vh6vqE7VXYmQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733464507; c=relaxed/simple;
	bh=2Hz7bllrvZJ6mSgpd7DZE1/ynwhKEKgE/iR489lGfgI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eDz1/kLIOYIFhrLg7ok/L3YkLjXAtsoHVrvEsmw7t5U9IM439jme/7oj4U66z2gVHRV+FHhAg2HziaoJLzJBCJbVISoIQ9VyF/JDx5a1aW/0hcwqZe/wPGsvCnMvoLpJLJBNtuDIoioQoBR3g00eXjES94aUjT/s8zH26DZo2/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=SBInrT2j; arc=none smtp.client-ip=185.125.188.121
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="SBInrT2j"
Received: from r41k0u-pc.. (unknown [106.222.213.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 11E8D3F38B;
	Fri,  6 Dec 2024 05:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1733464091;
	bh=9cuVk0t2hPWiMcYL9V7cadILQvDc5afLteeIkMM4klY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version;
	b=SBInrT2jXiocMoRxGYopEB2wBiTYHGl6s0glMPtwUFFEFnyS3rOLc6En9pVSIF9Zk
	 zRJmx2uLWwddgAozVtroHlG7MCy6IwwdZi1eMaRsSLX5FZb5RgXKHlOELlsZytNqei
	 vCEFKRGZsDpcbb2fRuZqJN/0Nm3XifDmuIxsDRaijOFgjCJgptGSx9Ef65r5Q7oJQ6
	 yONCL7MDnM5x3+O7QgL0gf3uDftb6SnRqUGy79GdEaq69jAmqN1+CznPe7V51BEPi8
	 5yZw4zeysAelqAznr3N4tyCEYBFgaSGGDaTytMPFx5A3JRucbeIdoBrxqeesUWC5Du
	 S9fjOeJqe2Log==
From: Pragyansh Chaturvedi <pragyansh.chaturvedi@canonical.com>
To: linux-trace-devel@vger.kernel.org
Cc: Pragyansh Chaturvedi <pragyansh.chaturvedi@canonical.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] libtraceevent: fix file endianness for big endian hosts
Date: Fri,  6 Dec 2024 11:17:38 +0530
Message-ID: <20241206054739.1431381-1-pragyansh.chaturvedi@canonical.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch initialises the file endianness to the same value as host endianness.
Without this, the file endianness is set to little endian by default, which
results in segfaults of libtracefs testsuite on big endian architectures
(libtracefs uses libtracevent, and my investigating led to this patch).
We can make a default assumption that the host and FS endianness is same.
If it is different, the user must set the correct endianness using the
event-parse-api (tep_set_file_bigendian)

After applying my fix, the run summary of utest/trace-utest of libtracefs:

Run Summary: Type Total Ran Passed Failed Inactive
              suites 1 1 n/a 0 0
               tests 36 36 35 1 0
             asserts 16407066 16407066 16407064 2 n/a

Elapsed time = 22.623 seconds 

Signed-off-by: Pragyansh Chaturvedi <pragyansh.chaturvedi@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 src/event-parse.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/src/event-parse.c b/src/event-parse.c
index 0427061..200e59a 100644
--- a/src/event-parse.c
+++ b/src/event-parse.c
@@ -8501,6 +8501,14 @@ struct tep_handle *tep_alloc(void)
 	if (tep) {
 		tep->ref_count = 1;
 		tep->host_bigendian = tep_is_bigendian();
+
+		/*
+		 * We can make the following safe assumption
+		 * for the default case. Else it leaves the
+		 * file endianness as little endian and breaks
+		 * things on big endian architectures.
+		 */
+		tep->file_bigendian = tep->host_bigendian;
 	}
 
 	return tep;
-- 
2.43.0

