Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87662154422
	for <linux-trace-devel@vger.kernel.org>; Thu, 22 Feb 2024 16:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708620912; cv=none; b=gdNexK7rzbTPjProLhvQmNwE29heqHHdIRcTB5mZlV69CkXtjfI9FTjV/nQvvcRCHqxZVF5kzF8KsPonC/FZqZm7HIohR/v5p3u7C6GRgP0fq6T+G8fDiAEfoVy7jq+A7xZXet9UgUQtEzX3AFEe2zpJ9VaSaue7SYhtyktwhPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708620912; c=relaxed/simple;
	bh=E8dfN/9hGgSohhPu4xMNcxxKV0FTBzXWnmJFZT+2xV8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=BhrDLAPrcliIJMa7AOV+Vzrkg2cVylMnswrflkIRtnLQb+vFzIkC9+Q8ogFAOPHJTm9SWSEvW7wg+fCyvpw90JuO38G0wf+sKlBY4SV/+zKU2APtbQMIgeLgHMsz5cgfIdcBo8Z1vmxTajuiGqCNs9iFoFUf8RNsjacqjyi1Ntc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01884DA7;
	Thu, 22 Feb 2024 08:55:46 -0800 (PST)
Received: from e126645.arm.com (unknown [10.57.50.6])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 756853F73F;
	Thu, 22 Feb 2024 08:55:06 -0800 (PST)
From: Pierre Gondois <pierre.gondois@arm.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Pierre Gondois <pierre.gondois@arm.com>
Subject: [PATCH v6 1/2] trace-cmd split: Remove const to (struct handle_list).name
Date: Thu, 22 Feb 2024 17:54:17 +0100
Message-Id: <20240222165418.2153026-1-pierre.gondois@arm.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

(struct handle_list).name was unnecessarily made const in:
commit caa9eda091d6 ("trace-cmd split: Store instances in local list")

Remove it.
Also fix bad indentation.

Signed-off-by: Pierre Gondois <pierre.gondois@arm.com>
---

Notes:
    v6:
    - New patch: Remove unnecessary const for (struct handle_list).name

 tracecmd/trace-split.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tracecmd/trace-split.c b/tracecmd/trace-split.c
index 2c311b3d..cb6242d8 100644
--- a/tracecmd/trace-split.c
+++ b/tracecmd/trace-split.c
@@ -53,9 +53,9 @@ struct cpu_data {
 
 struct handle_list {
 	struct list_head		list;
-	const char			*name;
+	char				*name;
 	int				index;
-	struct tracecmd_input 		*handle;
+	struct tracecmd_input		*handle;
 
 	/* Identify the top instance in the input trace. */
 	bool				was_top_instance;
@@ -114,7 +114,7 @@ static void free_handles(struct list_head *list)
 	while (!list_empty(list)) {
 		item = container_of(list->next, struct handle_list, list);
 		list_del(&item->list);
-		free((char *)item->name);
+		free(item->name);
 		tracecmd_close(item->handle);
 		free(item);
 	}
-- 
2.25.1

