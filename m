Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54ECD227397
	for <linux-trace-devel@vger.kernel.org>; Thu, 17 Oct 2024 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729195546; cv=none; b=EUXc/NsxxezFPvpcGsIGxL+phNNX8ecqV9er/Ntxils5kBz/HQvHhk2EC48RdmKMgQ8F0uYdneIbObRL6KwBK7aShsfiTYaUHz/tD11r44MdKynuXXOphuEFXMdby4lGAEGvbR3eDiad1er5QWgO8nYl12e840zZM0b0VAuWakA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729195546; c=relaxed/simple;
	bh=buzsaZnHnAntSoMLRcdU7/Kg3ecUfqpY50aQ+cHrD30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q94oHhaAxraor/PZqkoTBwqdM7vSQJbgUn8VhGXch2Fm3RM8yfHfLs8AtHw4V+d3C0P4B7a1erriYg32nTd8EmWnhrYDpyGDYA4+RixOKCmar+qILJJ9JzbHxcPmmaOWhFRbAb94hEQR7ouVmw+csAx08fmwFT8Nj5JpvhKTPmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F353DC4CED5;
	Thu, 17 Oct 2024 20:05:45 +0000 (UTC)
Received: from rostedt by gandalf with local (Exim 4.98)
	(envelope-from <rostedt@rostedt.homelinux.com>)
	id 1t1Wl8-00000003uhB-2EsW;
	Thu, 17 Oct 2024 16:06:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-trace-devel@vger.kernel.org
Cc: "Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Adrien Nader <adrien@notk.org>
Subject: [PATCH 2/3] libtracefs utest: Fix min percent test
Date: Thu, 17 Oct 2024 16:03:23 -0400
Message-ID: <20241017200609.932728-3-rostedt@goodmis.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241017200609.932728-1-rostedt@goodmis.org>
References: <20241017200609.932728-1-rostedt@goodmis.org>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

On PowerPC 64 which has 64K pages, it screws up the accounting of some
calculations used for tests. For instance, 1% of the ring buffer may not
be more than a page. So testing 1% and then subtracting the number of
events per page is going to lead to a negative number. This will obviously
fail.

Take into account that the subbuffer may be very large, and to make a
minimum percent to use in case a subbuffer size is greater than 1%.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=219358
Reported-by: Adrien Nader <adrien@notk.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 utest/tracefs-utest.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/utest/tracefs-utest.c b/utest/tracefs-utest.c
index 742f4546bef0..b5095a18bb16 100644
--- a/utest/tracefs-utest.c
+++ b/utest/tracefs-utest.c
@@ -1340,6 +1340,17 @@ static void test_cpu_read_buf_percent(struct test_cpu_data *data, int percent)
 
 	/* For percent == 0, just test for any data */
 	if (percent) {
+		int min_percent;
+
+		/*
+		 * For architectures like PowerPC with 64K PAGE_SIZE and thus
+		 * large sub buffers, where we will not have over 100 sub buffers
+		 * percent must at least cover more than 1 sub buffer.
+		 */
+		min_percent = (100 + (data->nr_subbufs - 1)) / data->nr_subbufs;
+		if (percent < min_percent)
+			percent = min_percent;
+
 		expect = data->nr_subbufs * data->events_per_buf * percent / 100;
 
 		/* Add just under the percent */
-- 
2.45.2

